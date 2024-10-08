/// Gets parameter one's hitbox then compares it to parameter two's position and hitbox
/// to check if there is a collision
/// returns true if there is a collision
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


/// Checks if the main character is near the mechanic
bool isNear(mainChar, mech) {
  // Check if the main character is near the mechanic
  return mainChar.position.distanceTo(mech.position) < 16;
}

