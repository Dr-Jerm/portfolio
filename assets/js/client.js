var root;

root = typeof exports !== "undefined" && exports !== null ? exports : this;

(function() {
  root.app = angular.module("myApp", ["ngAnimate"]);
  root.app.controller("portfolioController", function($scope, Server) {
    $scope.loaded = false;
    root.scrollTo(0, 0);
    $scope.innerHeight = root.innerHeight;
    $scope.getInnerHeightStyle = function(css) {
      var style;
      style = {};
      style[css] = $scope.innerHeight + 'px';
      return style;
    };
    root.addEventListener('resize', function() {
      $scope.innerHeight = root.innerHeight;
      return $scope.$apply();
    });
    return Server.getPortfolioData().then((function(portfolio) {
      $scope.works = portfolio.works;
      $scope.experiments = portfolio.experiments;
      return $scope.histories = portfolio.histories;
    }), function(error) {
      return console.error(error);
    });
  });
  root.addEventListener('touchmove', function(event) {
    if (event.touches.length === 2) {
      event.stopPropagation();
      return event.preventDefault();
    }
  });
  return console.log("Up and Running!");
})();

var Cube, CubeField, cubeCount, cubeSize, fieldRadius, root;

root = typeof exports !== "undefined" && exports !== null ? exports : this;

cubeCount = 15;

cubeSize = 40;

fieldRadius = 600;

CubeField = (function() {
  var cubes;

  cubes = [];

  function CubeField() {
    var i, randomPosition, s, t, x, y, z, _i;
    for (i = _i = 0; 0 <= cubeCount ? _i <= cubeCount : _i >= cubeCount; i = 0 <= cubeCount ? ++_i : --_i) {
      t = Math.random() * Math.PI;
      s = Math.random() * Math.PI * 2;
      x = (fieldRadius - 50) * Math.sin(t) * Math.cos(s);
      y = (fieldRadius - 50) * Math.sin(t) * Math.sin(s);
      z = (fieldRadius - 50) * Math.cos(t);
      randomPosition = new CANNON.Vec3(x, y, z);
      cubes.push(new Cube(randomPosition, fieldRadius));
    }
    this.update = function(timeStep) {
      var cube, _j, _len, _results;
      _results = [];
      for (_j = 0, _len = cubes.length; _j < _len; _j++) {
        cube = cubes[_j];
        _results.push(cube.update(timeStep));
      }
      return _results;
    };
  }

  return CubeField;

})();

Cube = (function() {
  var boundaryForceScale, randomForceScale, spinSpeed, worldRadius;

  spinSpeed = .05;

  randomForceScale = 100;

  boundaryForceScale = 50;

  worldRadius = void 0;

  function Cube(position, boundsRadius) {
    var geometry, getBoundaryForce, mass, material, shape, updateForces;
    worldRadius = boundsRadius;
    geometry = new THREE.CubeGeometry(cubeSize, cubeSize, cubeSize);
    material = new THREE.MeshLambertMaterial({
      color: 0xdddddd,
      shading: THREE.FlatShading
    });
    this.mesh = new THREE.Mesh(geometry, material);
    position.copy(this.mesh.position);
    root.scene.add(this.mesh);
    shape = new CANNON.Box(new CANNON.Vec3(cubeSize / 2, cubeSize / 2, cubeSize / 2));
    mass = 50;
    this.body = new CANNON.RigidBody(mass, shape);
    this.body.angularVelocity.set(((Math.random() - .5) * 2) * spinSpeed, ((Math.random() - .5) * 2) * spinSpeed, ((Math.random() - .5) * 2) * spinSpeed);
    this.body.angularDamping = 0;
    this.body.position = position;
    root.world.add(this.body);
    updateForces = function() {
      var boundaryForce, force, forces, netForce, randomForce, _i, _len;
      randomForce = new CANNON.Vec3(((Math.random() - .5) * 2) * randomForceScale, ((Math.random() - .5) * 2) * randomForceScale, ((Math.random() - .5) * 2) * randomForceScale);
      boundaryForce = getBoundaryForce();
      forces = [randomForce, boundaryForce];
      netForce = new CANNON.Vec3(0, 0, 0);
      for (_i = 0, _len = forces.length; _i < _len; _i++) {
        force = forces[_i];
        netForce = netForce.vadd(force);
      }
      return netForce;
    };
    getBoundaryForce = (function(_this) {
      return function() {
        var boundaryForce, distanceFromOrigin, pos;
        boundaryForce = new CANNON.Vec3(0, 0, 0);
        distanceFromOrigin = _this.body.position.distanceTo(boundaryForce);
        if (distanceFromOrigin > fieldRadius) {
          pos = position.copy();
          pos.normalize();
          boundaryForce = pos.mult(-1 * boundaryForceScale);
        }
        return boundaryForce;
      };
    })(this);
    this.update = function(timeStep) {
      var force, worldPoint;
      root.world.step(timeStep);
      force = updateForces();
      worldPoint = new CANNON.Vec3(0, 0, 0);
      this.body.applyForce(force, this.body.position);
      this.body.position.copy(this.mesh.position);
      return this.body.quaternion.copy(this.mesh.quaternion);
    };
    this;
  }

  return Cube;

})();

(function() {
  var animate, camera, clock, container, cubeField, frame, init, initCannon, onWindowResize, render, renderer, stats, time, timeStep, worldDepth, worldHalfDepth, worldHalfWidth, worldWidth;
  container = void 0;
  camera = void 0;
  root.scene = void 0;
  renderer = void 0;
  root.world = void 0;
  cubeField = void 0;
  time = void 0;
  frame = 0;
  timeStep = 1 / 60;
  stats = void 0;
  init = function() {
    var directionalLight;
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
    camera.position.z = 800;
    root.scene = new THREE.Scene();
    root.scene.fog = new THREE.FogExp2(0xedf7f2, 0.002);
    root.scene.add(new THREE.AmbientLight(0x666666));
    directionalLight = new THREE.DirectionalLight(0xedf7f2, 1);
    directionalLight.position.x = -0.1;
    directionalLight.position.y = 0.5;
    directionalLight.position.z = 0.7;
    directionalLight.position.normalize();
    root.scene.add(directionalLight);
    initCannon();
    cubeField = new CubeField();
    stats = new Stats();
    stats.domElement.style.position = 'absolute';
    stats.domElement.style.right = '0px';
    stats.domElement.style.top = '200px';
    return container.appendChild(stats.domElement);
  };
  onWindowResize = function() {
    camera.aspect = root.innerWidth / root.innerHeight;
    camera.updateProjectionMatrix();
    return renderer.setSize(root.innerWidth, root.innerHeight);
  };
  animate = function() {
    requestAnimationFrame(animate);
    cubeField.update();
    render();
    return stats.update();
  };
  render = function() {
    var delta;
    frame++;
    delta = clock.getDelta();
    time = clock.getElapsedTime() * 10;
    return renderer.render(root.scene, camera);
  };
  initCannon = function() {
    root.world = new CANNON.World();
    root.world.gravity.set(0, 0, 0);
    root.world.broadphase = new CANNON.NaiveBroadphase();
    return root.world.solver.iterations = 3;
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

root.app.directive('carouselle', function() {
  return {
    restrict: 'E',
    scope: {
      items: '='
    },
    templateUrl: 'partials/carouselle',
    link: function(scope, element, attrs) {
      scope.debug = function() {
        debugger;
      };
      scope.$watch('items', function() {
        if (scope.items) {
          return scope.itemCount = scope.items.length;
        }
      });
      scope.selected = 0;
      scope.left = true;
      scope.right = false;
      scope.getClass = function(index) {
        if (index === scope.selected) {
          if (scope.left) {
            return 'right';
          }
          if (scope.right) {
            return 'left';
          }
        }
        if (index > scope.selected) {
          return 'right';
        }
        if (index < scope.selected) {
          return 'left';
        }
      };
      return scope.switchTo = function(index) {
        if (index > scope.selected) {
          scope.left = true;
          scope.right = false;
        }
        if (index < scope.selected) {
          scope.right = true;
          scope.left = false;
        }
        scope.selected = index;
        return console.log(index);
      };
    }
  };
});

var root;

root = typeof exports !== "undefined" && exports !== null ? exports : this;

(function() {
  return root.app.factory('Server', function($q, $http) {
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
})();
