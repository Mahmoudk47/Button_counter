import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/button_provider.dart';

class TotalCounterCard extends StatefulWidget {
  const TotalCounterCard({super.key});

  @override
  State<TotalCounterCard> createState() => _TotalCounterCardState();
}

class _TotalCounterCardState extends State<TotalCounterCard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _previousCount = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ButtonProvider>(
      builder: (context, buttonProvider, child) {
        final totalCount = buttonProvider.totalCount;
        
        if (totalCount != _previousCount) {
          _animationController.reset();
          _animationController.forward();
          _previousCount = totalCount;
        }
        
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Total Count',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                ScaleTransition(
                  scale: _animation,
                  child: Text(
                    totalCount.toString(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}