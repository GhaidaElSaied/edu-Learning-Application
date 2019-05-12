#= require paper-full

window.InitializeBee = ->
    textShown = true
    
    # Array of paperjs circles representing the bee path
    beePath = []
    
    bee = document.getElementById("bee")

    p = new paper.Path.Rectangle(
        from: [0, 0],
        to: [50, 50]
    )
    
    
    
    beeForward = new paper.Point(1, 0)
    #Velocity from 0 to 1
    beeVelocityPercent = 0
    #Maximum velocity, when percent = 1
    beeVelocityMax = 1.5
    MAX_ROTATION = 1.5
    

    # MOVE_DISTANCE = 1
    # Bee will slow down within its max velocity multiplied by this distance, ~30+ needed to be able to turn towards locations to sides and behind bee
    SLOW_DISTANCE = 35
    STEP_TIME = 5
    destination = [0, 0]
    start = [0, 0]
    # Store ID of current path here
    currentMovement = 0
    # For forward vector rotation
    origin = new paper.Point(0, 0)
    distanceTravelled = 0
    looping = false
    loopPositive = false
    loopedDegrees = 0
    
    randSigned =  1 - 2 * Math.random()
    stepCount = 0
    ###
    pathOutline = new paper.Path(
        segments: [p.bounds.center],
        strokeColor: '#aaaa22',
        dashArray: [15, 10],
        strokeWidth: 5,
        strokeCap: 'round'
    )
    
    testPath = new paper.Path(
        segments: [p.bounds.center],
        strokeColor: 'black',
        strokeCap: 'round',
        strokeWidth: 2,
        dashArray: [15, 10]
    )
    ###

    MoveStep = ->
        # Distance from bee to destination
        distance = p.bounds.center.getDistance(destination)
        # console.log(distance)
        
        # Slow down
        if distance < beeVelocityMax * SLOW_DISTANCE
            looping = false
            beeVelocityPercent = Math.max(.1, (distance / (beeVelocityMax * SLOW_DISTANCE)))
            beeVelocityPercent = beeVelocityPercent * beeVelocityPercent
        # Speed up
        else if beeVelocityPercent < 1
            distanceTravelled =  p.bounds.center.getDistance(start)
            if distanceTravelled < beeVelocityMax
                beeVelocityPercent = Math.max(.1, (distanceTravelled / beeVelocityMax))
                beeVelocityPercent = beeVelocityPercent * beeVelocityPercent
                
                distanceTravelled += beeVelocityPercent * beeVelocityMax
            else
                beeVelocityPercent = 1
        
        # Rotate
        rand = Math.random()
        if looping == false && rand > .995
            looping = true
            loopedDegrees = 0
            if rand > .9975
                loopPositive = true
            else
                loopPositive = false
            
        
        destinationDirection = (destination.subtract(p.bounds.center)).normalize()
        
        angle = beeForward.getDirectedAngle(destinationDirection)
        
        # console.log("Before: " + angle)
        if looping
            if loopPositive
                beeForward = beeForward.rotate(MAX_ROTATION, origin)
                p.rotate(MAX_ROTATION)
                loopedDegrees += MAX_ROTATION
                if loopedDegrees > 350
                    looping = false
            else
                beeForward = beeForward.rotate(-MAX_ROTATION, origin)
                p.rotate(-MAX_ROTATION)
                loopedDegrees -= MAX_ROTATION
                if loopedDegrees < -350
                    looping = false
        else if angle > MAX_ROTATION
            # console.log("+")
            # console.log(beeForward.getDirectedAngle(destinationDirection))
            beeForward = beeForward.rotate(MAX_ROTATION, origin)
            # console.log(beeForward.getDirectedAngle(destinationDirection))
            p.rotate(MAX_ROTATION)
        else if angle < -MAX_ROTATION
            # console.log("-")
            # console.log(beeForward.getDirectedAngle(destinationDirection))
            beeForward = beeForward.rotate(-MAX_ROTATION, origin)
            # console.log(beeForward.getDirectedAngle(destinationDirection))
            p.rotate(-MAX_ROTATION)
        else
            beeForward = beeForward.rotate(angle, origin)
            p.rotate(angle)
            
        # console.log("After: " + beeForward.getDirectedAngle(destination.subtract(p.bounds.center)))
        
        randSigned = (.8 * randSigned) + (.2 * (1 - (rand * 2)))
        randAngle = 2 * randSigned
        if looping
            beeForward = beeForward.rotate(randAngle, origin)
            p.rotate(randAngle)
        else
            # Make effect noticeable when not looping without making loops look stupid
            beeForward = beeForward.rotate(3 * randAngle, origin)
            p.rotate(3 * randAngle)
        

        p.bounds.center = p.bounds.center.add(beeForward.multiply(beeVelocityMax * beeVelocityPercent))
        # testPath.add(p.bounds.center)
        # pathOutline.add(p.bounds.center)
        
        #Move bee
        # console.log(bee)
        bee.style.top = p.bounds.topLeft.y + "px"
        bee.style.left = p.bounds.topLeft.x + "px"
        newHeight = (60 + (40 * (p.bounds.topLeft.y / paper.project.view.viewSize.height)))
        $('img#bee').css("height", newHeight + "px");
        
        if beeForward.angle < 90 && beeForward.angle > -90
            # bee.style.transform = "rotate(" + -angle + "deg)"
            bee.style.transform = "scale(1, 1)"
        else
            # bee.style.transform = "rotate(" + -angle + "deg)"
            bee.style.transform = "scale(-1, 1)"

        if distance < 20 && angle < 10 && angle > -10
            clearInterval(currentMovement)
            currentMovement = 0
        #beePath.add([p.bounds.centerX, p.bounds.centerY])
        
        stepCount++
        drawDotPath(stepCount)
    
    
    # draws a circle and adds it to beeP
    drawDotPath = (count) ->
        if count % 5 == 0
            pathDot = new paper.Path.Circle(new paper.Point(p.bounds.centerX, p.bounds.centerY), 2);
            pathDot.fillColor = '#aaaa22';
            pathDot.sendToBack()
            beePath.push(pathDot)
            
        if count > 20
            trimDotPath() # So website works for now
            
    
    trimDotPath = () ->
        setIntervalX(( ->
            pathLength = beePath.length
            i = 0
            while pathLength > 100
                beePath[0].remove()
                beePath.splice(0, 1)
                pathLength--
            ),
        100, beePath.length/10)
    
    setIntervalX = (callback, delay, repetitions) ->
        x = 0
        # f0f8ff
        intervalID = window.setInterval((() ->
            callback()
            if ++x == repetitions 
                window.clearInterval(intervalID)
        ), delay)

    ###
    MoveStep = ->
      fwd = destination.subtract(p.position)
      fwd = fwd.normalize(MOVE_DISTANCE)
      #First part gets random number between -1 to 1, last constant multiplies by maximum rotation.
      randomRotation = (Math.random() - .5) * 2 * 50
      #Rotate forward vector around the bee by small random amount
      fwd = fwd.rotate(randomRotation, origin)
      p.position = p.position.add(fwd)
      if p.position.getDistance(destination) < MOVE_DISTANCE
        clearInterval currentMovement
        currentMovement = 0
      return
    ###
    
    textDiv = $("#instructions")
    FadeText = ->
        opac = parseFloat(textDiv.css("opacity"))
        if (opac == 0)
            clearInterval(textIntervalID)
        else
            opac -= .01
            textDiv.css("opacity", opac.toString())
    
    paper.project.view.onMouseDown = (event) ->
        if (textShown)
            textShown = false
            textIntervalID = setInterval(FadeText, 10)
        
        start = p.beeVelocityPercent
        destination = event.point
        if currentMovement != 0
            clearInterval(currentMovement)
            distanceTravelled = 0
            currentMovement = setInterval(MoveStep, STEP_TIME)
        else
            distanceTravelled = 0
            currentMovement = setInterval(MoveStep, STEP_TIME)
            
window.InitializeTree = ->
    flowers = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    flowers[0] = document.getElementById("one")
    flowers[1] = document.getElementById("two")
    flowers[2] = document.getElementById("three")
    flowers[3] = document.getElementById("four")
    flowers[4] = document.getElementById("five")
    flowers[5] = document.getElementById("six")
    flowers[6] = document.getElementById("seven")
    flowers[7] = document.getElementById("eight")
    flowers[8] = document.getElementById("nine")
    apples = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    apples[0] = document.getElementById("aone")
    apples[1] = document.getElementById("atwo")
    apples[2] = document.getElementById("athree")
    apples[3] = document.getElementById("afour")
    apples[4] = document.getElementById("afive")
    apples[5] = document.getElementById("asix")
    apples[6] = document.getElementById("aseven")
    apples[7] = document.getElementById("aeight")
    apples[8] = document.getElementById("anine")
    
    activeFlowers = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    hasPollen = false
    totalPollen = 0
    lastFlower = -1
    

    ActivateFlower = ->
        randIndex = Math.floor(Math.random() * 9)
        
        if (activeFlowers[randIndex] == 0)
            flowers[randIndex].style.opacity = 1
            activeFlowers[randIndex] = 1
    
    bee = document.getElementById("bee")
    FlowerInteraction = ->
        beePosition = bee.getBoundingClientRect()
        beeX = (beePosition.right + beePosition.left) / 2
        beeY = (beePosition.top + beePosition.bottom) / 2
        
        count = 0
        while (count < 9)
            if count != lastFlower && activeFlowers[count] == 1
                rect = flowers[count].getBoundingClientRect()
                flowerX = (rect.right + rect.left) / 2
                flowerY = (rect.top + rect.bottom) / 2
                a = (beeX - flowerX)
                b = (beeY - flowerY)
                dist = Math.sqrt( a*a + b*b )
                # console.log(dist)
                if (dist < 25)
                    if hasPollen == false
                        hasPollen = true
                        totalPollen += 1
                    else
                        flowers[count].style.opacity = 0
                        apples[count].style.opacity = 1
                        activeFlowers[count] = 2
                        hasPollen = false
                    
                    lastFlower = count
                        
            count++
    
    
    offset = [0, 0, 0, 0, 0, 0, 0, 0, 0]        
    HandleApples = ->
        count = 0
        while (count < 9)
            if activeFlowers[count] == 2
                offset[count] += 3
                apples[count].style.transform = "translate(0," + offset[count] + "px)"
                
                if (offset[count] > document.body.clientHeight)
                    console.log("reset")
                    apples[count].style.opacity = 0
                    offset[count] = 0
                    apples[count].style.transform = "translate(0, 0)"
                    activeFlowers[count] = 0
                    console.log(activeFlowers)
            
            count++
            
    setInterval(ActivateFlower, 2000)
    setInterval(FlowerInteraction, 50)
    setInterval(HandleApples, 20)
        