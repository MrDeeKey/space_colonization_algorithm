// http://algorithmicbotany.org/papers/colonization.egwnp2007.pdf

import 'dart:math';
import 'package:flutter/material.dart';

import 'branch.dart';
import 'leaf.dart';

const int leavesNumber = 5000;
const double influenceDistance = 200.0;
const double killDistance = 20;
const double len = 10;

class Tree {
  final Rect crownBounds;
  final List<Branch> rootBranches;
  final List<Leaf> leaves;
  final List<Branch> branches;

  Tree({required this.crownBounds, required this.rootBranches})
      : leaves = List.generate(
          leavesNumber,
          (int idx) => Leaf(
            pos: Offset(
              (Random().nextDouble()) * crownBounds.width,
              (Random().nextDouble()) * crownBounds.height,
            ),
          ),
        ),
        branches = rootBranches;

  void render(Canvas canvas) {
    for (Leaf leaf in leaves) {
      leaf.render(canvas);
    }
    for (Branch branch in branches) {
      branch.render(canvas);
    }
  }

  void grow(double dt) {
    final Map<Branch, List<Leaf>> branchLeafMap = {};
    for (int leafIdx = 0; leafIdx < leaves.length; leafIdx++) {
      final Leaf leaf = leaves[leafIdx];
      double shortestDist = double.maxFinite;
      Branch? closestBranch;
      for (Branch branch in branches) {
        final double dist = (leaf.pos - branch.pos).distance;
        if (dist <= killDistance) {
          leaf.markedToDelete = true;
          closestBranch = null;
          break;
        }
        if (dist <= influenceDistance && dist <= shortestDist) {
          closestBranch = branch;
          shortestDist = dist;
        }
      }

      if (closestBranch != null) {
        if (branchLeafMap[closestBranch] == null) {
          branchLeafMap[closestBranch] = [];
        }
        branchLeafMap[closestBranch]!.add(leaf);
      }
    }
    branchLeafMap.forEach((branch, leaves) {
      Offset dir = leaves.fold<Offset>(const Offset(0, 0),
          (dir, leaf) => dir + (leaf.pos - branch.pos) / (leaf.pos - branch.pos).distance);
      dir = dir / dir.distance;
      dir = Offset.lerp(dir, branch.dir, 0.7)!;
      branches.add(Branch(pos: branch.pos + dir * len, parent: branch, dir: dir));
    });

    final int leavesLen = leaves.length;
    for (int leafIdx = leavesLen - 1; leafIdx >= 0; leafIdx--) {
      if (leaves[leafIdx].markedToDelete) {
        leaves.removeAt(leafIdx);
      }
    }
  }
}
