# edu-Learning-Application

Medium Article: https://medium.com/@ghaidae/by-ghaida-el-saied-nick-meier-estephan-rustom-omar-beyhum-and-nick-bajaj-773846f4ac8e

# INTRODUCTION

As part of our final project for our User Interface Design and Development (CS160) course at the University of California, Berkeley, we were tasked with building an application that leverages concepts of cool media. Our assignment was open ended, and our only constraint was that we could not design for ourselves. Using user-centric design principles, we brainstormed, researched, observed, and prototyped, implemented and evaluated our application.

We created an application geared towards upper elementary and lower middle school students. Our application is a learning tool, with interactive tasks that teach you academic concepts before you read the text. We swayed from the traditional approach towards education, which would be to provide definitions, textbook reading, and assignments that quiz dry knowledge. Instead, our application has the user read last and interact with the real world first. By completing our tasks, users will fully understand how concepts that are learned in the classroom can have a real world impact. It is our goal that by engaging users, they will have the desire to be more creative and be progress oriented students.

Group Members: Ghaida El-Saied, Omar Beyhum, Steve Rustom, Nick Bajaj, Nick Meier

# Code Implementation

For the bee interaction, all the images were HTML elements. The apples were animated using CSS directly, and the bee was animated by using a gif image. The bee uses a basic pathfinding system to move to the tapped location. It tracks a forward vector and a velocity, and it accelerates to a max velocity and stays there until it gets close to its target, where its velocity is slowed using an easing function.

The forward vector contains the direction the bee moves. The bee has a max rotation rate for its forward vector, and it will try to rotate its forward vector so that it is facing its target. It has a chance to enter a loop where the forward vector will rotate 360 degrees. Randomization is added to the movement by adding a slight random offset to the normal rotation. This offset uses a partial update (.25*new + .75*old) to have smoother random movements. The randomization is less strong when looping.

Vectors were done in paper.js and html elements were positioned with the data from paper.js. A function was called every 50 MS to handle the bee flower interaction. If the bee was within range of the flower it would gather pollen and if it went to a different flower it would pollinate the flower, and turn it into an apple. The apple and the flower were separate HTML elements that were switched on and off. The apple was moved using its transform and when it fell off the screen it would reset the flower and a flower could grow again.
The bee’s path was drawn based on the bee’s position and it was made of paper circles so they could be easily cleared.

For the leaf interaction, most of the work was in the canvas HTML tag and manipulating its properties through javascript. By using the camera API, we could request a user to take a photo, and then draw a downscaled, resized version of it on the canvas. Reducing the image’s resolution when on the canvas was essential to reduce the processing time required for changing its color and therefore offer a fluid, non-blocking experience for users when manipulating the slider. As for recoloring the leaf, we would get the canvas’ image data and sift through it to specifically target pixels with a green-ish hue and apply canny edge detection.

The sine wave that shows the rate of photosynthesis was drawn using paperjs through an update function that we would call every 10 MS. The update function added a new point at a given x offset, and y was given by a repeating sine function multiplied by the photosynthesis rate constant that was determined from our inputs. Once the path was extended for more than one x offset past the edge of the screen, it was shifted back by one x offset and the earliest remaining point was removed. The peak height of the sine wave was determined by a coefficient which also controlled the leaf’s hue: The greener the hue, the greater the peak height. This coefficient would be modified through the season slider, which we implemented by using a default jquery slider element that we would reskin by modifying its background color and applying a custom CSS linear gradient with multiple stops representing different seasons.
