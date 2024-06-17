bool checkCollision(player, block) {
  final hitbox = player.hitbox;

  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

  final blockX = block.position.x;
  final blockY = block.position.y;
  final blockWidth = block.size.x;
  final blockHeight = block.size.y;

  final fixedX = player.scale.x < 0 ? playerX - (hitbox.offsetX * 2) : playerX;
  final fixedY = player.scale.y < 0 ? playerY - (hitbox.offsetY * 2) : playerY;

  // Check for a collision
  return(fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX &&
      fixedY < blockY + blockHeight &&
      fixedY + playerHeight > blockY);
}

