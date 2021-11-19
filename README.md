# boids
My attempt at the famous flocking algorithm

After a long long tme of not doing any recreational coding i sat down and wrote the famous "Boids" algorithm that mimics flocking behaviour in birds / fish etc..
I find this small bit of code fascinating - How simple rules can produce complex and beautiful behaviour.
The algorithm is very simple:
Each "boid" is guided by three rules.
1. fly towrds those around you - ATTRACTION
2. fly away if you are about to crash - REPULSION
3. fly towards the general direction of the flock - ALIGNMENT
I decided to give each rule a field of influence.
It makes sense that your guiding rule would be to get closer to others when you're far away and not worry about crashing until you're close to others - so i made the attraction radius bigger. The alignment radius is somewhere in the middle of the two.
I also made each value changeable with the keyboard in order to increase their influence on the final vector of the boid.
Notice that for most of the video the behaviour is erratic- until i crank up the alignment and they really do adjust course.

https://www.facebook.com/watch/?v=417250532637534
