.pragma library

function score(entry, counts) {
  return counts[entry.id || entry.name] || 0;
}

function results(applications, query, counts) {
  return query.startsWith(">") ? [
  {
    kind: "command",
    command: query.slice(1).trim()
  }
] : applications.map(object => {
  const stxt = query.toLowerCase();
  const ntxt = object.name.toLowerCase();
  let ni = 0;

  let matches = [];
  let startMatch = -1;

  for (let si = 0; si != stxt.length; ++si) {
    const sc = stxt[si];

    while (true) {
      if (ni == ntxt.length)
        return null;

      const nc = ntxt[ni++];

      if (nc == sc) {
        if (startMatch == -1)
          startMatch = ni;
        break;
      } else {
        if (startMatch != -1) {
          matches.push({
            index: startMatch,
            length: ni - startMatch
          });

          startMatch = -1;
        }
      }
    }
  }

  if (startMatch != -1) {
    matches.push({
      index: startMatch,
      length: ni - startMatch + 1
    });
  }

  return {
    object: object,
    matches: matches
  };
}).filter(entry => entry !== null).sort((a, b) => {
  if (query === "") {
    const frequency = score(b.object, counts) - score(a.object, counts);
    if (frequency !== 0) return frequency;
  }
  let ai = 0;
  let bi = 0;
  let s = 0;

  while (ai != a.matches.length && bi != b.matches.length) {
    const am = a.matches[ai];
    const bm = b.matches[bi];

    s = bm.length - am.length;
    if (s != 0)
      return s;

    s = am.index - bm.index;
    if (s != 0)
      return s;

    ++ai;
    ++bi;
  }

  s = a.matches.length - b.matches.length;
  if (s != 0)
    return s;

  s = a.object.name.length - b.object.name.length;
  if (s != 0)
    return s;

  return a.object.name.localeCompare(b.object.name);
}).map(entry => ({
      kind: "app",
      object: entry.object
    }));
}
