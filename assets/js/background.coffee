root = exports ? this

## use randomSeed as frame offset for tail pos

class Vector3
    
    constructor: (x, y, z) ->
        @x = x
        @y = y
        @z = z
        
        @multiply = (scale) ->
            @x = @x*scale
            @y = @y*scale
            @z = @z*scale
            @
            
        @add = (incrementorVector) ->
            @x = @x+incrementorVector.x
            @y = @y+incrementorVector.y
            @z = @z+incrementorVector.z
            @

        @length = ->
            Math.sqrt(@.x*@.x + @.y*@.y + @.z*@.z)

        @normalize = ->
            length = @length()
            @x = @x / length
            @y = @y / length
            @z = @z / length
            @
            
class Snake 
    tailCount = 6
    tailReduction = 0.8
    tailOffset = 20
    maxVelocity = 3
    
    mass = 10
    
    speedScale = 0.01
    
    randomForceScale = 100
    boundaryForceScale = 50

    positionBuffer = []
    rotationBuffer = []

    position = new Vector3(0,0,0)
    
    velocity = new Vector3(0,0,0)


    tailSections = []

    constructor: (bounds) ->
        @bounds = bounds

        scale = 1

        for i in [0..tailCount]
            section = new SnakeSection(scale, i*tailOffset)

            tailSections.push(section)
            root.scene.add(section.group)
            scale = scale * tailReduction

    update: (delta, frame) =>
        scale = 1
        
        updatePhysics(delta)

        updateBuffers()

        for section,i in tailSections
            sectionPosition = positionBuffer[i*tailOffset]
            sectionRotation = rotationBuffer[i*tailOffset]
            if sectionPosition
                section.update(sectionPosition, sectionRotation, delta, frame)
            

    updatePhysics = (delta) ->
        randomForce = new Vector3(((Math.random()-.5)*2)*randomForceScale, ((Math.random()-.5)*2)*randomForceScale, ((Math.random()-.5)*2)*randomForceScale)
        
        boundaryForce = getBoundaryForce()

        forces = [randomForce, boundaryForce]
        
        netForce = new Vector3(0,0,0)

        for force in forces
            netForce.add(force)
            
        acceleration = netForce.multiply(1/mass)
        
        newVelocity = acceleration.multiply(delta).add(velocity) ## a*t + v(i) = v(f)

        newVelocity.x = Math.min(newVelocity.x, maxVelocity)
        newVelocity.y = Math.min(newVelocity.y, maxVelocity)
        newVelocity.z = Math.min(newVelocity.z, maxVelocity)

        velocity = newVelocity
        
        position.add(velocity);

    updateBuffers = ->
        positionBuffer.unshift(angular.copy(position))

        rotation = angular.copy(velocity).normalize()

        rotationBuffer.unshift(rotation)

        if positionBuffer.length > (tailOffset * tailCount+1) 
            positionBuffer.pop()
            rotationBuffer.pop()



    getBoundaryForce = ->
        distanceFromOrigin = position.length()

        boundaryForce = new Vector3(0,0,0)

        if distanceFromOrigin > 400
            boundaryForce = angular.copy(position).normalize().multiply(-1*boundaryForceScale)

        boundaryForce



class SnakeSection

    undulateSpeed = 1/10
    undulateScale = 1/10

    birthRate = 0.005

    vertexRandomScale = 4 ##8
    baseGeoSize = 70

    constructor: (inScale, offset) ->
        birthScale = 0

        scale = inScale;

        offset =  offset ##Math.floor(Math.random()*100)

        origVerts = []

        @update = (position, rotation, delta, frame) ->
            undulateAmount = 1 + ((Math.sin((frame+offset)*undulateSpeed))*undulateScale)

            if birthScale < scale
                birthScale += birthRate
                # undulateAmount = undulateAmount * birthScale

            @mesh.scale = new Vector3(undulateAmount,undulateAmount,undulateAmount*1.5)

            randomizeVerticies(@mesh.geometry)
            @group.position = position

            @mesh.lookAt(rotation)
            # @mesh.rotation.x = rotation.x + Math.PI/2
            # @mesh.rotation.y = rotation.y  + Math.PI/2
            # @mesh.rotation.z = rotation.z + Math.PI/2

        createMesh = (scale) ->

            geometry = createGeo(scale);
            geometry.dynamic = true

            geometry.computeFaceNormals()
            geometry.computeVertexNormals()

            material = new THREE.MeshLambertMaterial( { color: 0xdddddd, shading: THREE.FlatShading} )

            newMesh = new THREE.Mesh( geometry, material )

            newMesh.scale = new Vector3(0,0,0)

            # newMesh.rotation.x = Math.PI/2

            newMesh

        createGeo = (scale) ->
            geometry = new THREE.SphereGeometry( baseGeoSize*scale, 32*scale, 16*scale );
            origVerts = angular.copy geometry.vertices
            randomizeVerticies(geometry)
            geometry

        randomizeVerticies = (geo) ->
            geo.vertices = resetVerts geo.vertices, origVerts
            for vertex,i in geo.vertices

                vertex.y = vertex.y + vertexRandomScale*(Math.random() - 0.5)
                vertex.x = vertex.x + vertexRandomScale*(Math.random() - 0.5)
                vertex.z = vertex.z + vertexRandomScale*(Math.random() - 0.5)

            geo.verticesNeedUpdate = true;
            geo.normalsNeedUpdate = true;

        resetVerts = (from, to) ->
            for v,i in from
                from[i].x = to[i].x
                from[i].y = to[i].y
                from[i].z = to[i].z
            from


        @mesh = createMesh(scale)
        @group = new THREE.Object3D()
        # @group.rotation.x = 90*Math.PI/180
        # @group.rotation.z = 90*Math.PI/180
        @group.add(@mesh)

        

(->
    container = undefined

    camera = undefined
    root.scene = undefined
    renderer = undefined

    mesh = undefined
    geometry = undefined
    material = undefined

    time = undefined
    frame = 0

    snake = undefined

    stats = undefined

    init = ->
        renderer = new THREE.WebGLRenderer()
        renderer.setClearColor( 0xffffff, 1 )
        renderer.setSize( root.innerWidth, root.innerHeight )

        container = document.getElementById( 'container' )

        camera = new THREE.PerspectiveCamera( 60, root.innerWidth / root.innerHeight, 1, 20000 )
        container.innerHTML = ""

        container.appendChild( renderer.domElement )

        root.addEventListener( 'resize', onWindowResize, false )

        camera.position.z = 600

        root.scene = new THREE.Scene()
        root.scene.fog = new THREE.FogExp2( 0xffffff, 0.002  )

        root.scene.add( new THREE.AmbientLight( 0x666666 ) );

        directionalLight = new THREE.DirectionalLight( 0xffffff, 1 );

        directionalLight.position.x = -0.1;
        directionalLight.position.y = 0.5;
        directionalLight.position.z = 0.7;

        directionalLight.position.normalize();

        root.scene.add( directionalLight );


        snake = new Snake("bounds")

        stats = new Stats()
        stats.domElement.style.position = 'absolute'
        stats.domElement.style.right = '0px'
        stats.domElement.style.top = '0px'
        container.appendChild( stats.domElement )

     onWindowResize = -> 
        camera.aspect = root.innerWidth / root.innerHeight
        camera.updateProjectionMatrix()

        renderer.setSize( root.innerWidth, root.innerHeight )

    animate = ->
        requestAnimationFrame( animate )
        render()

        stats.update()

    render = ->

        frame++
        delta = clock.getDelta()
        time = clock.getElapsedTime() * 10

        # for ( var i = 0, l = geometry.vertices.length i < l i ++ ) {

        #     geometry.vertices[ i ].y = 35 * Math.sin( i / 5 + ( time + i ) / 7 )

        # }

        # randomizeVerticies(mesh.geometry)

        if delta < 1.0
            snake.update(delta, frame)

        # mesh.geometry.verticesNeedUpdate = true
        renderer.render( root.scene, camera )

    worldWidth = 128
    worldDepth = 128
    worldHalfWidth = worldWidth / 2
    worldHalfDepth = worldDepth / 2

    clock = new THREE.Clock()

    init()
    animate()
 
)()