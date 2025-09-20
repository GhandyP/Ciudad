import 'package:flutter/material.dart';
import '../models/piece.dart';
import '../models/position.dart';

class ChessPiece extends StatelessWidget {
  final Piece piece;
  final double size;
  final VoidCallback? onTap;

  const ChessPiece({
    super.key,
    required this.piece,
    this.size = 40,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _getPieceColor(),
          border: Border.all(
            color: _getBorderColor(context),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 2,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Center(
          child: Text(
            piece.symbol,
            style: TextStyle(
              fontSize: size * 0.7,
              height: 1,
              color: _getTextColor(),
            ),
          ),
        ),
      ),
    );
  }

  Color _getPieceColor() {
    // Para Petteia, todas las piezas son stones con el mismo color base
    return piece.color == PieceColor.white
        ? const Color(0xFFFFF9E6)
        : const Color(0xFF4A4A4A);
  }

  Color _getBorderColor(BuildContext context) {
    return piece.color == PieceColor.white
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;
  }

  Color _getTextColor() {
    return piece.color == PieceColor.white
        ? Colors.black
        : Colors.white;
  }
}

// Widget para mostrar una pieza con animación
class AnimatedChessPiece extends StatefulWidget {
  final Piece piece;
  final double size;
  final VoidCallback? onTap;
  final bool isMoving;

  const AnimatedChessPiece({
    super.key,
    required this.piece,
    this.size = 40,
    this.onTap,
    this.isMoving = false,
  });

  @override
  State<AnimatedChessPiece> createState() => _AnimatedChessPieceState();
}

class _AnimatedChessPieceState extends State<AnimatedChessPiece>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isMoving) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnimatedChessPiece oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isMoving != oldWidget.isMoving) {
      if (widget.isMoving) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
        _animationController.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: ChessPiece(
        piece: widget.piece,
        size: widget.size,
        onTap: widget.onTap,
      ),
    );
  }
}