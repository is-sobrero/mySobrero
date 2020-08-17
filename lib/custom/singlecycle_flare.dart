import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';

class SingleCycleController extends FlareController {
  final String _animation;
  final double _mix;
  ActorAnimation _actor;
  double _duration = 0;

  SingleCycleController(this._animation, [this._mix = 0.5]);

  @override
  void initialize(FlutterActorArtboard artBoard) {
    _actor = artBoard.getAnimation(_animation);
  }

  @override
  bool advance(FlutterActorArtboard artBoard, double elapsed) {
    _duration += elapsed;

    if (_duration >= _actor.duration) {
      isActive.value = false;
      return false;
    }
    _actor.apply(_duration, artBoard, _mix);
    return true;
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}
}
