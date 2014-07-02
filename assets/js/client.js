var root;

root = typeof exports !== "undefined" && exports !== null ? exports : this;

(function() {
  root.app = angular.module("myApp", ["ngAnimate"]);
  root.app.controller("portfolioController", function($scope, $timeout, Server) {
    $scope.loaded = false;
    $scope.innerHeight = root.innerHeight;
    $scope.getInnerHeightStyle = function(css) {
      var style;
      style = {};
      style[css] = $scope.innerHeight + 'px';
      return style;
    };
    root.addEventListener('resize', function() {
      $scope.innerHeight = root.innerHeight;
      $scope.innerWidth = root.innerWidth;
      return $scope.$apply();
    });
    return Server.getPortfolioData().then((function(portfolio) {
      $scope.achievements = portfolio.achievements;
      $scope.badges = portfolio.badges;
      return $timeout(function() {
        root.scrollTo(0, 0);
        return $scope.loaded = true;
      }, 3000);
    }), function(error) {
      return console.error(error);
    });
  });
  return console.log("Up and Running!");
})();

var root;

root = typeof exports !== "undefined" && exports !== null ? exports : this;

(function() {
  var animate, camera, clock, container, frame, geometry, init, mesh, onWindowResize, render, renderer, time, timeStep, worldDepth, worldHalfDepth, worldHalfWidth, worldWidth;
  container = void 0;
  camera = void 0;
  root.scene = void 0;
  renderer = void 0;
  root.world = void 0;
  mesh = void 0;
  geometry = void 0;
  time = void 0;
  frame = 0;
  timeStep = 1 / 60;
  init = function() {
    var i, material, vert, _i, _len, _ref;
    renderer = new THREE.WebGLRenderer({
      antialias: true
    });
    renderer.setClearColor(0xedf7f2, 1);
    renderer.setSize(root.innerWidth, root.innerHeight);
    container = document.getElementById('container');
    camera = new THREE.PerspectiveCamera(60, root.innerWidth / root.innerHeight, 1, 20000);
    container.innerHTML = "";
    container.appendChild(renderer.domElement);
    root.addEventListener('resize', onWindowResize, false);
    camera.position.y = 400;
    camera.rotation.x = -(Math.PI / 3);
    root.scene = new THREE.Scene();
    root.scene.fog = new THREE.FogExp2(0xedf7f2, 0.004);
    geometry = new THREE.PlaneGeometry(2000, 2000, 40, 40);
    geometry.applyMatrix(new THREE.Matrix4().makeRotationX(-Math.PI / 2));
    geometry.dynamic = true;
    _ref = geometry.vertices;
    for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
      vert = _ref[i];
      vert.y = 35 * Math.sin(i / 2);
    }
    geometry.computeFaceNormals();
    geometry.computeVertexNormals();
    material = new THREE.MeshLambertMaterial({
      color: 0x000000,
      wireframe: true
    });
    mesh = new THREE.Mesh(geometry, material);
    return root.scene.add(mesh);
  };
  onWindowResize = function() {
    camera.aspect = root.innerWidth / root.innerHeight;
    camera.updateProjectionMatrix();
    return renderer.setSize(root.innerWidth, root.innerHeight);
  };
  animate = function() {
    requestAnimationFrame(animate);
    return render();
  };
  render = function() {
    var delta, i, vert, _i, _len, _ref;
    frame++;
    delta = clock.getDelta();
    time = clock.getElapsedTime() * 10;
    _ref = geometry.vertices;
    for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
      vert = _ref[i];
      vert.y = 35 * Math.sin(i / 5 + (time + i) / 7);
    }
    mesh.geometry.verticesNeedUpdate = true;
    return renderer.render(root.scene, camera);
  };
  worldWidth = 128;
  worldDepth = 128;
  worldHalfWidth = worldWidth / 2;
  worldHalfDepth = worldDepth / 2;
  clock = new THREE.Clock();
  init();
  return animate();
})();

var root;

root = typeof exports !== "undefined" && exports !== null ? exports : this;

root.app.directive('blob', function() {
  return {
    restrict: 'E',
    scope: {
      details: '='
    },
    replace: true,
    templateUrl: 'partials/blob',
    link: function(scope, element, attrs) {
      console.log('blob ' + scope.details.title + ' loaded!');
      scope.tileCount = function() {
        if (root.innerWidth < 500) {
          return {
            "width": "100%"
          };
        }
        if (root.innerWidth < 800) {
          return {
            "width": "50%"
          };
        }
        return {
          "width": "33.33%"
        };
      };
      return scope.fontSize = function() {
        if (root.innerWidth < 800) {
          return {
            "font-size": "90%"
          };
        }
        return {
          "font-size": "100%"
        };
      };
    }
  };
});

root.app.directive('badge', function() {
  return {
    restrict: 'A',
    scope: {
      details: '='
    },
    templateUrl: 'partials/badge'
  };
});

var root;

root = typeof exports !== "undefined" && exports !== null ? exports : this;

(function() {
  root.app.factory('Server', function($q, $http) {
    var getPortfolioData;
    getPortfolioData = function() {
      var deferred;
      deferred = $q.defer();
      $http.get('/api/portfolio').then((function(response) {
        return deferred.resolve(response.data);
      }), function(error) {
        return deferred.reject(error);
      });
      return deferred.promise;
    };
    return {
      getPortfolioData: getPortfolioData
    };
  });
  return root.app.factory('Loader', function($q) {
    var Loader, promises;
    promises = [];
    Loader = {
      loaded: false,
      push: function(promise) {
        return promises.push(promise);
      },
      register: function() {
        return $q.all(promises).then(function(results) {
          return Loader.loaded = true;
        });
      }
    };
    return Loader;
  });
})();
