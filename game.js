
var Module;

if (typeof Module === 'undefined') Module = eval('(function() { try { return Module || {} } catch(e) { return {} } })()');

if (!Module.expectedDataFileDownloads) {
  Module.expectedDataFileDownloads = 0;
  Module.finishedDataFileDownloads = 0;
}
Module.expectedDataFileDownloads++;
(function() {
 var loadPackage = function(metadata) {

    var PACKAGE_PATH;
    if (typeof window === 'object') {
      PACKAGE_PATH = window['encodeURIComponent'](window.location.pathname.toString().substring(0, window.location.pathname.toString().lastIndexOf('/')) + '/');
    } else if (typeof location !== 'undefined') {
      // worker
      PACKAGE_PATH = encodeURIComponent(location.pathname.toString().substring(0, location.pathname.toString().lastIndexOf('/')) + '/');
    } else {
      throw 'using preloaded data can only be done on a web page or in a web worker';
    }
    var PACKAGE_NAME = 'game.data';
    var REMOTE_PACKAGE_BASE = 'game.data';
    if (typeof Module['locateFilePackage'] === 'function' && !Module['locateFile']) {
      Module['locateFile'] = Module['locateFilePackage'];
      Module.printErr('warning: you defined Module.locateFilePackage, that has been renamed to Module.locateFile (using your locateFilePackage for now)');
    }
    var REMOTE_PACKAGE_NAME = typeof Module['locateFile'] === 'function' ?
                              Module['locateFile'](REMOTE_PACKAGE_BASE) :
                              ((Module['filePackagePrefixURL'] || '') + REMOTE_PACKAGE_BASE);
  
    var REMOTE_PACKAGE_SIZE = metadata.remote_package_size;
    var PACKAGE_UUID = metadata.package_uuid;
  
    function fetchRemotePackage(packageName, packageSize, callback, errback) {
      var xhr = new XMLHttpRequest();
      xhr.open('GET', packageName, true);
      xhr.responseType = 'arraybuffer';
      xhr.onprogress = function(event) {
        var url = packageName;
        var size = packageSize;
        if (event.total) size = event.total;
        if (event.loaded) {
          if (!xhr.addedTotal) {
            xhr.addedTotal = true;
            if (!Module.dataFileDownloads) Module.dataFileDownloads = {};
            Module.dataFileDownloads[url] = {
              loaded: event.loaded,
              total: size
            };
          } else {
            Module.dataFileDownloads[url].loaded = event.loaded;
          }
          var total = 0;
          var loaded = 0;
          var num = 0;
          for (var download in Module.dataFileDownloads) {
          var data = Module.dataFileDownloads[download];
            total += data.total;
            loaded += data.loaded;
            num++;
          }
          total = Math.ceil(total * Module.expectedDataFileDownloads/num);
          if (Module['setStatus']) Module['setStatus']('Downloading data... (' + loaded + '/' + total + ')');
        } else if (!Module.dataFileDownloads) {
          if (Module['setStatus']) Module['setStatus']('Downloading data...');
        }
      };
      xhr.onload = function(event) {
        var packageData = xhr.response;
        callback(packageData);
      };
      xhr.send(null);
    };

    function handleError(error) {
      console.error('package error:', error);
    };
  
      var fetched = null, fetchedCallback = null;
      fetchRemotePackage(REMOTE_PACKAGE_NAME, REMOTE_PACKAGE_SIZE, function(data) {
        if (fetchedCallback) {
          fetchedCallback(data);
          fetchedCallback = null;
        } else {
          fetched = data;
        }
      }, handleError);
    
  function runWithFS() {

    function assert(check, msg) {
      if (!check) throw msg + new Error().stack;
    }
Module['FS_createPath']('/', 'visor', true, true);
Module['FS_createPath']('/', 'buttons', true, true);
Module['FS_createPath']('/', 'img', true, true);
Module['FS_createPath']('/', 'lib', true, true);
Module['FS_createPath']('/', 'general', true, true);

    function DataRequest(start, end, crunched, audio) {
      this.start = start;
      this.end = end;
      this.crunched = crunched;
      this.audio = audio;
    }
    DataRequest.prototype = {
      requests: {},
      open: function(mode, name) {
        this.name = name;
        this.requests[name] = this;
        Module['addRunDependency']('fp ' + this.name);
      },
      send: function() {},
      onload: function() {
        var byteArray = this.byteArray.subarray(this.start, this.end);

          this.finish(byteArray);

      },
      finish: function(byteArray) {
        var that = this;

        Module['FS_createDataFile'](this.name, null, byteArray, true, true, true); // canOwn this data in the filesystem, it is a slide into the heap that will never change
        Module['removeRunDependency']('fp ' + that.name);

        this.requests[this.name] = null;
      },
    };

        var files = metadata.files;
        for (i = 0; i < files.length; ++i) {
          new DataRequest(files[i].start, files[i].end, files[i].crunched, files[i].audio).open('GET', files[i].filename);
        }

  
    function processPackageData(arrayBuffer) {
      Module.finishedDataFileDownloads++;
      assert(arrayBuffer, 'Loading data file failed.');
      assert(arrayBuffer instanceof ArrayBuffer, 'bad input to processPackageData');
      var byteArray = new Uint8Array(arrayBuffer);
      var curr;
      
        // copy the entire loaded file into a spot in the heap. Files will refer to slices in that. They cannot be freed though
        // (we may be allocating before malloc is ready, during startup).
        if (Module['SPLIT_MEMORY']) Module.printErr('warning: you should run the file packager with --no-heap-copy when SPLIT_MEMORY is used, otherwise copying into the heap may fail due to the splitting');
        var ptr = Module['getMemory'](byteArray.length);
        Module['HEAPU8'].set(byteArray, ptr);
        DataRequest.prototype.byteArray = Module['HEAPU8'].subarray(ptr, ptr+byteArray.length);
  
          var files = metadata.files;
          for (i = 0; i < files.length; ++i) {
            DataRequest.prototype.requests[files[i].filename].onload();
          }
              Module['removeRunDependency']('datafile_game.data');

    };
    Module['addRunDependency']('datafile_game.data');
  
    if (!Module.preloadResults) Module.preloadResults = {};
  
      Module.preloadResults[PACKAGE_NAME] = {fromCache: false};
      if (fetched) {
        processPackageData(fetched);
        fetched = null;
      } else {
        fetchedCallback = processPackageData;
      }
    
  }
  if (Module['calledRun']) {
    runWithFS();
  } else {
    if (!Module['preRun']) Module['preRun'] = [];
    Module["preRun"].push(runWithFS); // FS is not initialized yet, wait for it
  }

 }
 loadPackage({"files": [{"audio": 0, "start": 0, "crunched": 0, "end": 2388, "filename": "/main.lua"}, {"audio": 0, "start": 2388, "crunched": 0, "end": 4760, "filename": "/visor/visor.lua"}, {"audio": 0, "start": 4760, "crunched": 0, "end": 7073, "filename": "/visor/cabbages.lua"}, {"audio": 0, "start": 7073, "crunched": 0, "end": 9412, "filename": "/visor/hand.lua"}, {"audio": 0, "start": 9412, "crunched": 0, "end": 11051, "filename": "/buttons/anims.lua"}, {"audio": 0, "start": 11051, "crunched": 0, "end": 18117, "filename": "/buttons/buttons.lua"}, {"audio": 0, "start": 18117, "crunched": 0, "end": 30942, "filename": "/img/gameover.png"}, {"audio": 0, "start": 30942, "crunched": 0, "end": 33460, "filename": "/img/butt1_var2.png"}, {"audio": 0, "start": 33460, "crunched": 0, "end": 64157, "filename": "/img/rocket_sheet_vert.png"}, {"audio": 0, "start": 64157, "crunched": 0, "end": 66212, "filename": "/img/butt2_sheet_var1.png"}, {"audio": 0, "start": 66212, "crunched": 0, "end": 68573, "filename": "/img/butt4_var1.png"}, {"audio": 0, "start": 68573, "crunched": 0, "end": 70740, "filename": "/img/butt4_var2.png"}, {"audio": 0, "start": 70740, "crunched": 0, "end": 79276, "filename": "/img/bigbutton_press.png"}, {"audio": 0, "start": 79276, "crunched": 0, "end": 132101, "filename": "/img/explosion_gameover.png"}, {"audio": 0, "start": 132101, "crunched": 0, "end": 134436, "filename": "/img/butt3_var2.png"}, {"audio": 0, "start": 134436, "crunched": 0, "end": 136926, "filename": "/img/butt2_sheet_var2.png"}, {"audio": 0, "start": 136926, "crunched": 0, "end": 145476, "filename": "/img/hand_push.png"}, {"audio": 0, "start": 145476, "crunched": 0, "end": 148801, "filename": "/img/overlay2.png"}, {"audio": 0, "start": 148801, "crunched": 0, "end": 201307, "filename": "/img/bottomBG.png"}, {"audio": 0, "start": 201307, "crunched": 0, "end": 203783, "filename": "/img/butt1_var1.png"}, {"audio": 0, "start": 203783, "crunched": 0, "end": 216586, "filename": "/img/bigbutton.png"}, {"audio": 0, "start": 216586, "crunched": 0, "end": 227003, "filename": "/img/cabbages.png"}, {"audio": 0, "start": 227003, "crunched": 0, "end": 235911, "filename": "/img/top_bgloop.png"}, {"audio": 0, "start": 235911, "crunched": 0, "end": 247040, "filename": "/img/hand_idle.png"}, {"audio": 0, "start": 247040, "crunched": 0, "end": 249360, "filename": "/img/butt3_var1.png"}, {"audio": 0, "start": 249360, "crunched": 0, "end": 252227, "filename": "/lib/box.lua"}, {"audio": 0, "start": 252227, "crunched": 0, "end": 256800, "filename": "/lib/vector.lua"}, {"audio": 0, "start": 256800, "crunched": 0, "end": 258582, "filename": "/general/general.lua"}], "remote_package_size": 258582, "package_uuid": "226d94ad-ee3a-4879-8a00-297c95613a7a"});

})();
