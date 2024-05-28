dictionary fastestTimes; // Dictionary to store fastest times per checkpoint
bool showUI = true;

// Called when the plugin is loaded
void Init() {
    print("FastestTimeTracker Initialized!");
}

// Called when a map is loaded
void OnMapLoaded() {
    print("A new map has been loaded!");
    fastestTimes.DeleteAll(); // Reset fastest times for a new map
}

// Called when a checkpoint is passed
void OnCheckpointPassed(CSmPlayer@ player, int checkpointIndex, bool isFinish) {
    if (isFinish) return; // Skip if the checkpoint is the finish line

    float currentTime = player.Score.PrevLapTimes[0];
    string checkpointKey = "" + checkpointIndex;

    if (!fastestTimes.Exists(checkpointKey)) {
        fastestTimes.Set(checkpointKey, currentTime);
    } else {
        float recordedTime;
        fastestTimes.Get(checkpointKey, recordedTime);
        if (currentTime < recordedTime) {
            fastestTimes.Set(checkpointKey, currentTime);
        }
    }
}

// Function to format time in mm:ss:fff
string FormatTime(float time) {
    int minutes = int(time) / 60000;
    int seconds = (int(time) / 1000) % 60;
    int milliseconds = int(time) % 1000;
    return "" + minutes + ":" + (seconds < 10 ? "0" : "") + seconds + ":" + (milliseconds < 100 ? "0" : "") + (milliseconds < 10 ? "0" : "") + milliseconds;
}

// Called every frame to render UI
void Render() {
    if (!showUI) return;

    UI::Begin("Fastest Time Tracker", showUI);
    UI::Text("Fastest Times Per Flag:");

    array<string> keys = fastestTimes.GetKeys();
    for (uint i = 0; i < keys.Length; i++) {
        string key = keys[i];
        float time;
        fastestTimes.Get(key, time);
        UI::Text("Flag " + key + ": " + FormatTime(time));
    }

    UI::End();
}

// Called when the plugin is unloaded
void Unload() {
    print("FastestTimeTracker Unloaded!");
}
