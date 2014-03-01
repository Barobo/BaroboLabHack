// Generated by CoffeeScript 1.7.1
var Robot, event, rand, rb, robots, x;

robots = ['3TCZ', 'PJHF'];

rand = function(min, max) {
  return Math.floor(Math.random() * (max - min) + min);
};

angular.module('challenge', []).directive('eqnGraph', function() {
  return {
    compile: function(element, attrs) {
      element.css({
        width: '400px',
        height: '400px'
      });
      return function(scope, element, attrs) {
        return scope.$watchCollection("[" + attrs.eqnConfig + ", " + attrs.eqnData + "]", function(_arg) {
          var cfg, data;
          cfg = _arg[0], data = _arg[1];
          return $.plot(element, data, cfg);
        });
      };
    }
  };
}).filter('plusMinus', function() {
  return function(x, unary) {
    var x_;
    if (unary == null) {
      unary = false;
    }
    x_ = Math.abs(x);
    if (x >= 0) {
      if (unary || x === 0) {
        return x;
      } else {
        return "+ " + x_;
      }
    } else {
      if (unary) {
        return "-" + x_;
      } else {
        return "- " + x_;
      }
    }
  };
}).controller('Challenge', function($scope) {
  $scope.mockRobot = (Robot.mock != null) && Robot.mock;
  $scope.solnX = rand(-10, 10);
  return $scope.solnY = rand(-10, 10);
}).controller('StandardEqns', function($scope) {
  var x, _ref;
  $scope.selected = [0, 0];
  _ref = (function() {
    var _i, _results;
    _results = [];
    for (x = _i = 0; _i <= 5; x = ++_i) {
      _results.push(rand(-10, 10));
    }
    return _results;
  })(), $scope.x1 = _ref[0], $scope.y1 = _ref[1], $scope.z1 = _ref[2], $scope.x2 = _ref[3], $scope.y2 = _ref[4], $scope.z2 = _ref[5];
  $scope.a1 = $scope.a2 = $scope.b1 = $scope.b2 = 0;
  $scope.$watch(function() {
    return [$scope.x1, $scope.y1, $scope.z1, $scope.x2, $scope.y2, $scope.z2];
  }, function() {
    $scope.a1 = -$scope.x1 / $scope.y1;
    $scope.b1 = $scope.z1 / $scope.y1;
    $scope.a2 = -$scope.x2 / $scope.y2;
    return $scope.b2 = $scope.z2 / $scope.y2;
  }, true);
  $scope.changeSelected = function(robot, left) {
    return $scope.$apply(function() {
      if (left) {
        if ($scope.selected[robot] > 0) {
          return $scope.selected[robot] -= 1;
        }
      } else {
        if ($scope.selected[robot] < 2) {
          return $scope.selected[robot] += 1;
        }
      }
    });
  };
  return $scope.incrementSelected = function(robot, up) {
    return $scope.$apply(function() {
      var coefficient, idx, sel;
      sel = $scope.selected[robot];
      idx = robot + 1;
      coefficient = (sel === 0 ? "x" : sel === 1 ? "y" : "z") + idx;
      if (up) {
        return $scope[coefficient] += 1;
      } else {
        return $scope[coefficient] -= 1;
      }
    });
  };
}).controller('InterceptEqns', function($scope) {
  var x, _ref;
  _ref = (function() {
    var _i, _results;
    _results = [];
    for (x = _i = 0; _i <= 3; x = ++_i) {
      _results.push(rand(-10, 10));
    }
    return _results;
  })(), $scope.a1 = _ref[0], $scope.b1 = _ref[1], $scope.a2 = _ref[2], $scope.b2 = _ref[3];
  $scope.selected = [0, 0];
  $scope.changeSelected = function(robot, left) {
    return $scope.$apply(function() {
      if (left) {
        if ($scope.selected[robot] > 0) {
          return $scope.selected[robot] -= 1;
        }
      } else {
        if ($scope.selected[robot] < 1) {
          return $scope.selected[robot] += 1;
        }
      }
    });
  };
  return $scope.incrementSelected = function(robot, up) {
    return $scope.$apply(function() {
      var coefficient, idx, sel;
      sel = $scope.selected[robot];
      idx = robot + 1;
      coefficient = (sel === 0 ? "a" : sel === 1 ? "b" : void 0) + idx;
      if (up) {
        return $scope[coefficient] += 1;
      } else {
        return $scope[coefficient] -= 1;
      }
    });
  };
}).controller('Graph', function($scope, $element) {
  var chartCfg, mkSeries;
  $scope.chartCfg = chartCfg = {
    grid: {
      markings: [
        {
          linewidth: 1,
          yaxis: {
            from: 0,
            to: 0
          },
          color: "#8A8A8A"
        }, {
          linewidth: 1,
          xaxis: {
            from: 0,
            to: 0
          },
          color: "#8A8A8A"
        }
      ]
    },
    xaxis: {
      min: -10,
      max: 10,
      tickSize: 2,
      tickDecimals: 0
    },
    yaxis: {
      min: -10,
      max: 10,
      tickSize: 2,
      tickDecimals: 0
    },
    colors: ["black", "red", "blue"]
  };
  mkSeries = function(a1, b1, a2, b2, solnX, solnY) {
    var a, b, s, x;
    s = (function() {
      var _i, _len, _ref, _ref1, _results;
      _ref = [[a1, b1], [a2, b2]];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        _ref1 = _ref[_i], a = _ref1[0], b = _ref1[1];
        _results.push((function() {
          var _j, _len1, _ref2, _results1;
          _ref2 = [-10, 10];
          _results1 = [];
          for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
            x = _ref2[_j];
            _results1.push([x, a * x + b]);
          }
          return _results1;
        })());
      }
      return _results;
    })();
    s.unshift({
      data: [[solnX, solnY]],
      points: {
        show: true
      }
    });
    return s;
  };
  $scope.serieses = mkSeries($scope.a1, $scope.b1, $scope.a2, $scope.b2, $scope.solnX, $scope.solnY);
  return $scope.$watch(function() {
    return [$scope.a1, $scope.b1, $scope.a2, $scope.b2, $scope.solnX, $scope.solnY];
  }, function(_arg) {
    var a1, a2, b1, b2, solnX, solnY;
    a1 = _arg[0], b1 = _arg[1], a2 = _arg[2], b2 = _arg[3], solnX = _arg[4], solnY = _arg[5];
    return $scope.serieses = mkSeries(a1, b1, a2, b2, solnX, solnY);
  }, true);
});

Robot = (function() {
  var _i, _j, _len, _len1, _ref, _ref1;
  if (Robot != null) {
    return Robot;
  } else {
    rb = {
      mock: true
    };
    _ref = ["connectRobot", "disconnectRobot", "getRobotIDList", "moveNB", "printMessage", "setColorRGB", "setJointSpeeds", "stop"];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      x = _ref[_i];
      rb[x] = function() {};
    }
    _ref1 = ["scrollUp", "scrollDown", "buttonChanged"];
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      event = _ref1[_j];
      rb[event] = {
        connect: function() {}
      };
    }
    return rb;
  }
})();

$(function() {
  var _i, _len;
  for (_i = 0, _len = robots.length; _i < _len; _i++) {
    x = robots[_i];
    Robot.connectRobot(x);
  }
  Robot.setColorRGB(robots[0], 255, 0, 0);
  return Robot.setColorRGB(robots[1], 0, 0, 255);
});

window.onbeforeunload = function() {
  var _i, _len;
  Robot.setColorRGB(robots[0], 0, 255, 0);
  Robot.setColorRGB(robots[1], 0, 255, 0);
  for (_i = 0, _len = robots.length; _i < _len; _i++) {
    x = robots[_i];
    Robot.disconnectRobot(x);
  }
  return null;
};

Robot.buttonChanged.connect(function(id, btn) {
  var activeTab;
  activeTab = $(".tab-pane.active");
  return activeTab.scope().changeSelected(robots.indexOf(id), btn === 0);
});

Robot.scrollDown.connect(function(id) {
  var activeTab;
  activeTab = $(".tab-pane.active");
  return activeTab.scope().incrementSelected(robots.indexOf(id), false);
});

Robot.scrollUp.connect(function(id) {
  var activeTab;
  activeTab = $(".tab-pane.active");
  return activeTab.scope().incrementSelected(robots.indexOf(id), true);
});
