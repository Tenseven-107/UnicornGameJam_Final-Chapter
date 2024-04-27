extends EffectPlayer



# Particles
export (Array, NodePath) var particle_paths: Array
onready var particles: Array



# Get the particles
func get_particles():
	var particle_array: Array
	for path in particle_paths:
		var particle = get_node(path)
		particle_array.append(particle)

	particles = particle_array



# Play the effect
func play_effect():
	if particles.empty() == true:
		get_particles()

	for particle in particles:
		particle.emitting = true
