# Ruby warrior player 
# Author: Jozef Lang <www.jozeflang.com>
# 
# Level 4

class Player

  # Health value from previous turn
  @health

  # Direction of bounded enemies
  @bounded_enemies = nil

  # A list of alive units
  @alive_units = nil

  def play_turn(warrior)

  	init_player_instance_values(warrior)

  	if is_enemy_near?(warrior) 
  		# Fight an enemy if any is near
  		_nearest_enemy = get_nearest_enemy(warrior)
  		warrior.bind!(_nearest_enemy)
  		@bounded_enemies.push(_nearest_enemy)
  	elsif warrior.health < 20 and warrior.health >= @health
  		# Rest if took any damage, but if and only if is not under attack
  		warrior.rest!
  	elsif @bounded_enemies.size > 0 
  		# Attack bounded enemies nearby
  		warrior.attack!(@bounded_enemies.pop)
  	elsif is_captive_near?(warrior)
  		# Rescue captive if nearby. 
  		# All bounded enemies (which looks like captives) are already dead due to previous if branch.
  		warrior.rescue!(get_nearest_captive(warrior))
  	elsif exists_live_units?
  		# If any live unit exists go to it and find out what it is
  		warrior.walk!(warrior.direction_of(@alive_units[0]))
  	else 
  		# If nothing is alive in the room, find the stairs
	    warrior.walk!(warrior.direction_of_stairs)	
	end

	# Update health
	@health = warrior.health

	if exists_live_units? and warrior.feel(warrior.direction_of(@alive_units[0])).empty?
		# Check whether chasen alive unit is dead already.
		# If yes, listen again
		@alive_units = warrior.listen
	end
  end

  def init_player_instance_values(warrior)
  	'''
  	Inits/updates player instance values
  	'''

  	if @health == nil 
  		@health = warrior.health
  	end

  	if @bounded_enemies == nil 
  		@bounded_enemies = Array.new
  	end

  	if @alive_units == nil
  		@alive_units = warrior.listen
  	end

  end

  def get_nearest_enemy(warrior)
  	'''
  	Returns nearest enemy in following direction: forward, backward, left, right. If none is near, returns nil
  	'''
  	return [:forward, :backward, :left, :right].detect { |d| warrior.feel(d).enemy? == true }
  end

  def is_enemy_near?(warrior)
  	'''
  	Returns whether an enemy is near. A enemy is near if it is located on the field next to the warrior.
  	Fields are inspected in following order: forward, backward, left, right
  	'''
  	return [:forward, :backward, :left, :right].any? { |d| warrior.feel(d).enemy? == true }
  end

  def is_captive_near?(warrior)
  	'''
  	Returns whether an captive is near. A captive is near if it is located on the field next to the warrior.
  	Fields are inspected in following order: forward, backward, left, right
  	'''
  	return [:forward, :backward, :left, :right].any? { |d| warrior.feel(d).captive? == true }
  end

  def get_nearest_captive(warrior)
  	'''
  	Returns nearest captive in following direction: forward, backward, left, right. If none is near, returns nil
  	'''
  	return [:forward, :backward, :left, :right].detect { |d| warrior.feel(d).captive? == true }
  end

  def exists_live_units?()
  	'''
  	Returns true if there are any units alive
  	'''
  	return @alive_units.size > 0
  end

end
