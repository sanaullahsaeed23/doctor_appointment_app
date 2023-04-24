
import 'package:flutter/material.dart';


class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  final Color color;
  RoundButton({Key? key,
    required this.title,
    required this.onTap,
    this.loading = false,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Center(child: loading ? const CircularProgressIndicator(strokeWidth: 4, color: Colors.white,):
        Text(title, style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),),
        ),
      ),
    );
  }
}


class RoundButtonColor extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;
  final bool loading;


  RoundButtonColor({Key? key,
    required this.title,
    required this.color,
    required this.onTap,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Center(
        child: Text(title, style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),),
        ),
      ),
    );
  }
}


class RoundButtonClose extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;
  final bool loading;


  RoundButtonClose({Key? key,
    required this.title,
    required this.color,
    required this.onTap,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 34,
        width: MediaQuery.of(context).size.width / 6,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Center(
          child: Text(title, style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),),
        ),
      ),
    );
  }
}