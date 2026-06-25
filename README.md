# NetPulse Web

Live reporting dashboard for the [NetPulse](https://github.com/karlvzilec-lang/NetPulse) Android drive-test app.  
Reads all telemetry from Supabase in real time — no backend required.

## Features

| Tab | What you see |
|---|---|
| **Dashboard** | 8 KPI cards · Speed trend chart · RSRP signal distribution · Recent tests live table |
| **Network** | Throughput + latency time-series · RAT breakdown bar chart · Full speed-test log |
| **CX Experience** | CX score trend · OpenSignal radar · CX log · OS scores table |
| **Drive Test** | MapLibre GL JS route map · Color-coded RSRP dots · Session sidebar · Sample detail table |

All four tabs update in real time as the Android app syncs data to Supabase.

## Setup

### 1. Enable Supabase Realtime

In the Supabase SQL editor (project `bauiffaqfboqlqnmxffc`), run:

```sql
-- supabase/enable-realtime.sql
ALTER PUBLICATION supabase_realtime ADD TABLE networkxp_data;
ALTER PUBLICATION supabase_realtime ADD TABLE cx_experience_log;
ALTER PUBLICATION supabase_realtime ADD TABLE opensignal_scores;
ALTER PUBLICATION supabase_realtime ADD TABLE drive_sessions;
ALTER PUBLICATION supabase_realtime ADD TABLE drive_samples;
```

### 2. Add your Supabase anon key

Open `index.html` and replace the placeholder near the top of the `<script>` block:

```js
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY_HERE'
```

Paste the **anon / public** key from  
*Supabase → Project Settings → API → Project API Keys → anon public*.

### 3. Open the dashboard

Open `index.html` directly in any modern browser — no build step, no server required.  
For production, deploy to GitHub Pages, Netlify, or any static host.

## Column mapping

If your Supabase schema uses different column names, edit the `C` object near the top of the script:

```js
const C = {
  nx:   { dl: 'download_mbps', ul: 'upload_mbps', ping: 'ping_ms', ... },
  cx:   { score: 'score', op: 'operator', ... },
  samp: { lat: 'lat', lng: 'lng', rsrp: 'rsrp', ... },
  ...
}
```

## RSRP color bands

Matches the validated engineering bands used in the Android app:

| Color | Range | Label |
|---|---|---|
| 🟢 Green  | ≥ −80 dBm  | Excellent |
| 🔵 Cyan   | −80…−90    | Good |
| 🟡 Yellow | −90…−100   | Fair |
| 🟠 Orange | −100…−110  | Poor |
| 🔴 Red    | < −110     | Critical |

## Stack

- **[MapLibre GL JS](https://maplibre.org/maplibre-gl-js/docs/)** — vendor-neutral maps (same tile stack as the Android app)
- **[OpenFreeMap](https://openfreemap.org/)** — keyless tile hosting (`liberty` style)
- **[Supabase JS v2](https://supabase.com/docs/reference/javascript/)** — data + realtime subscriptions
- **[Chart.js 4](https://www.chartjs.org/)** — time-series, doughnut, bar, radar charts
- Zero build tooling — single `index.html`, CDN imports only
