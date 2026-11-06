import QtQuick
import QtQuick.Controls
import qs.modules.common
import QtQuick.Layouts
import qs.services
import qs.modules.common.widgets

EncoreCard {
    id: root
    implicitHeight: 240; radius: 13
    property bool editingCity: false
    function saveCity() {
        const city = cityInput.text.trim()
        if (!city.length) return
        Config.options.bar.weather.enableGPS = false
        Config.options.bar.weather.city = city
        Weather.gpsActive = false
        editingCity = false
        Weather.getData()
    }
    ColumnLayout {
        anchors.fill: parent; anchors.margins: 14; spacing: 9
        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                Layout.fillWidth: true; spacing: 1
                EncoreText { text: Weather.data.description || "WEATHER"; font.pixelSize: 10; font.bold: true; color: EncoreStyle.muted; Layout.fillWidth: true }
                EncoreText { text: Weather.data.lastRefresh ? Weather.data.temp : "—°"; font.pixelSize: 35; font.bold: true }
                EncoreText { text: Weather.data.lastRefresh ? Weather.data.city : "Fetching forecast…"; font.pixelSize: 11; Layout.fillWidth: true }
            }
            EncoreButton { symbol: "edit_location_alt"; implicitWidth: 27; implicitHeight: 27; padding: 2; hint: "Choose weather city"; onClicked: { root.editingCity = !root.editingCity; if (root.editingCity) { cityInput.text = Config.options.bar.weather.city; cityInput.forceActiveFocus() } } }
            MaterialSymbol { visible: !root.editingCity; text: String(Weather.data.wCode) === "113" ? "clear_day" : "cloud"; iconSize: 40; color: EncoreStyle.lavender }
            EncoreButton { symbol: "refresh"; implicitWidth: 27; implicitHeight: 27; padding: 2; hint: "Refresh weather"; enabled: !Weather.loading; onClicked: Weather.getData() }
        }
        RowLayout {
            visible: root.editingCity
            Layout.fillWidth: true
            TextField {
                id: cityInput
                objectName: "encoreWeatherCity"
                Layout.fillWidth: true; implicitHeight: 32
                placeholderText: "City, country"
                color: EncoreStyle.text; placeholderTextColor: EncoreStyle.muted
                font.pixelSize: 12; padding: 7
                background: Rectangle { radius: 7; color: EncoreStyle.surface; border.width: 1; border.color: EncoreStyle.outline }
                onAccepted: root.saveCity()
                Accessible.name: "Weather city"
            }
            EncoreButton { text: "Set"; implicitHeight: 32; padding: 5; enabled: cityInput.text.trim().length > 0; onClicked: root.saveCity() }
        }
        RowLayout {
            Layout.fillWidth: true; spacing: 5
            Repeater {
                model: [{label:"HUMIDITY", value: Weather.data.lastRefresh ? Weather.data.humidity : "—"}, {label:"WIND", value: Weather.data.lastRefresh ? Weather.data.wind : "—"}, {label:"UV", value: Weather.data.lastRefresh ? Weather.data.uv : "—"}]
                Rectangle {
                    required property var modelData
                    Layout.fillWidth: true; implicitHeight: 40; color: EncoreStyle.surface; radius: 7
                    ColumnLayout { anchors.centerIn: parent; spacing: 1; EncoreText { text: parent.parent.modelData.label; font.pixelSize: 8; color: EncoreStyle.muted } EncoreText { text: String(parent.parent.modelData.value); font.bold: true; font.pixelSize: 12 } }
                }
            }
        }
        RowLayout {
            Layout.fillWidth: true
            Repeater {
                model: Weather.data.hourly || []
                ColumnLayout {
                    required property var modelData
                    Layout.fillWidth: true; spacing: 3
                    EncoreText { text: Math.round(Number(Weather.useUSCS ? parent.modelData.tempF : parent.modelData.tempC)) + "°"; font.pixelSize: 10; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                    EncoreText { text: String(Math.floor(Number(parent.modelData.time) / 100)).padStart(2,"0"); font.pixelSize: 9; color: EncoreStyle.muted; Layout.alignment: Qt.AlignHCenter }
                }
            }
        }
        EncoreText { text: Weather.loading ? "Updating forecast…" : Weather.error || Weather.data.lastRefresh || "Choose your city with the location button"; font.pixelSize: 8; color: Weather.error ? EncoreStyle.pink : EncoreStyle.muted; Layout.fillWidth: true; wrapMode: Text.Wrap }
    }
}
