Module["preRun"] = Module["preRun"] || [];
Module["preRun"].push(function () {
    addRunDependency("database");

    FS.mkdir("/database");
    FS.mount(IDBFS, { autoPersist: true }, "/database");

    FS.syncfs(true, function (error) {
        if (error) {
            abort("Datenbank konnte nicht geladen werden: " + error);
            return;
        }
        removeRunDependency("database");
    });
});