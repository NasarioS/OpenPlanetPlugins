// main.as

[Setting category="TrackFastestTimeRoyal"]
bool showUI = true;

[Setting hidden]
bool isEnabled = true;

dictionary fastestTimes; // Dictionary to store fastest times per flag
bool showUI = true;

// Called when the plugin is loaded
void Init() {
    print("TrackFastestTimeRoyal Initialized!");
}

// Called when a map is loaded
void OnMapLoaded() {
    print("A new map has been loaded!");
    fastestTimes.DeleteAll(); // Reset fastest times for a new map
}

// Called when a checkpoint is passed
void OnCheckpointPassed(CMlScriptPlayer@ player, int checkpointIndex, bool isFinish) {
    if (isFinish) return; // Skip if the checkpoint is the finish line

    float currentTime = player.User.TotalTime;
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

// Called every frame to render UI
void Render() {
    if (showUI) {
        UI::Begin("Fastest Time Tracker Royal", showUI);
        UI::Text("Fastest Times Per Flag:");

        array<string> keys = fastestTimes.GetKeys();
        for (uint i = 0; i < keys.Length; i++) {
            string key = keys[i];
            float time;
            fastestTimes.Get(key, time);
            UI::Text("Flag " + key + ": " + Time::Format(time));
        }

        UI::End();
    }
}

// Called when the plugin is unloaded
void Unload() {
    print("TrackFastestTimeRoyal Unloaded!");
}
