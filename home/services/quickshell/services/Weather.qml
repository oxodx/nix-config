pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick
import QtPositioning

import qs.modules.common

Singleton {
    id: root
    // 10 minute
    readonly property int fetchInterval: Config.options.bar.weather.fetchInterval * 60 * 1000
    readonly property string city: Config.options.bar.weather.city
    readonly property bool useUSCS: Config.options.bar.weather.useUSCS
    property bool gpsActive: Config.options.bar.weather.enableGPS

    onUseUSCSChanged: refreshDebounce.restart()
    onCityChanged: refreshDebounce.restart()
    onGpsActiveChanged: {
        if (gpsActive) positionSource.start()
        else positionSource.stop()
        refreshDebounce.restart()
    }
    readonly property bool loading: fetcher.running
    property string error: ""
    property bool refreshQueued: false
    Timer { id: refreshDebounce; interval: 350; onTriggered: root.getData() }

    property var location: ({
        valid: false,
        lat: 0,
        lon: 0
    })

    property var data: ({
        uv: 0,
        humidity: 0,
        sunrise: 0,
        sunset: 0,
        windDir: 0,
        wCode: 0,
        city: 0,
        wind: 0,
        precip: 0,
        visib: 0,
        press: 0,
        temp: 0,
        tempFeelsLike: 0,
        lastRefresh: 0,
    })

    function refineData(data) {
        let temp = {};
        temp.uv = data?.current?.uvIndex || 0;
        temp.humidity = (data?.current?.humidity || 0) + "%";
        temp.sunrise = data?.astronomy?.sunrise || "0.0";
        temp.sunset = data?.astronomy?.sunset || "0.0";
        temp.windDir = data?.current?.winddir16Point || "N";
        temp.wCode = data?.current?.weatherCode || "113";
        temp.city = !root.gpsActive && root.city.trim() ? root.city.trim() : data?.location?.areaName?.[0]?.value || "City";
        temp.temp = "";
        temp.tempFeelsLike = "";
        if (root.useUSCS) {
            temp.wind = (data?.current?.windspeedMiles || 0) + " mph";
            temp.precip = (data?.current?.precipInches || 0) + " in";
            temp.visib = (data?.current?.visibilityMiles || 0) + " m";
            temp.press = (data?.current?.pressureInches || 0) + " psi";
            temp.temp += (data?.current?.temp_F || 0);
            temp.tempFeelsLike += (data?.current?.FeelsLikeF || 0);
            temp.temp += "°F";
            temp.tempFeelsLike += "°F";
        } else {
            temp.wind = (data?.current?.windspeedKmph || 0) + " km/h";
            temp.precip = (data?.current?.precipMM || 0) + " mm";
            temp.visib = (data?.current?.visibility || 0) + " km";
            temp.press = (data?.current?.pressure || 0) + " hPa";
            temp.temp += (data?.current?.temp_C || 0);
            temp.tempFeelsLike += (data?.current?.FeelsLikeC || 0);
            temp.temp += "°C";
            temp.tempFeelsLike += "°C";
        }
        temp.description = data?.current?.weatherDesc?.[0]?.value || "";
        temp.hourly = data?.forecast?.[0]?.hourly || [];
        temp.forecast = data?.forecast || [];
        temp.lastRefresh = DateTime.time + " • " + DateTime.date;
        root.data = temp;
    }

    function getData() {
        if (fetcher.running) { refreshQueued = true; return }
        error = ""
        const query = gpsActive && location.valid ? location.lat + "," + location.lon : city.trim()
        fetcher.command = ["curl", "--fail", "--silent", "--show-error", "--connect-timeout", "6", "--max-time", "18", "--retry", "1", "--retry-delay", "1", "https://wttr.in/" + encodeURIComponent(query) + "?format=j1"]
        fetcher.running = true
    }

    Component.onCompleted: { if (gpsActive) positionSource.start() }

    Process {
        id: fetcher
        stdout: StdioCollector { id: weatherOutput }
        stderr: StdioCollector {}
        onExited: (code, exitStatus) => {
            if (root.refreshQueued) {
                root.refreshQueued = false
                refreshDebounce.restart()
                return
            }
            try {
                if (code !== 0) throw new Error("network")
                const raw = JSON.parse(weatherOutput.text)
                if (!raw.current_condition?.length || !raw.nearest_area?.length) throw new Error("forecast")
                root.refineData({current: raw.current_condition[0], location: raw.nearest_area[0], astronomy: raw.weather?.[0]?.astronomy?.[0], forecast: raw.weather || []})
                root.error = ""
            } catch (error) {
                root.error = "Forecast couldn't load. Check your city or try again."
            }
        }
    }

    PositionSource {
        id: positionSource
        updateInterval: root.fetchInterval

        onPositionChanged: {
            // update the location if the given location is valid
            // if it fails getting the location, use the last valid location
            if (position.latitudeValid && position.longitudeValid) {
                root.location.lat = position.coordinate.latitude;
                root.location.lon = position.coordinate.longitude;
                root.location.valid = true;
                // console.info(`📍 Location: ${position.coordinate.latitude}, ${position.coordinate.longitude}`);
                root.getData();
                // if can't get initialized with valid location deactivate the GPS
            } else {
                root.gpsActive = root.location.valid ? true : false;
                console.error("[WeatherService] Failed to get the GPS location.");
            }
        }

        onValidityChanged: {
            if (!positionSource.valid) {
                positionSource.stop();
                root.location.valid = false;
                root.gpsActive = false;
                Quickshell.execDetached(["notify-send", Translation.tr("Weather Service"), Translation.tr("Cannot find a GPS service. Using the fallback method instead."), "-a", "Shell"]);
                console.error("[WeatherService] Could not aquire a valid backend plugin.");
            }
        }
    }

    Timer {
        running: true
        repeat: true
        interval: Math.max(60000, root.fetchInterval)
        triggeredOnStart: true
        onTriggered: root.getData()
    }
}
