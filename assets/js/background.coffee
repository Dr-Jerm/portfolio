root = exports ? this

# use randomSeed as frame offset for tail pos

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
            
class Snake 
    tailCount = 3
    tailReduction = 0.5
    tailOffset = 200
    maxVelocity = 3
    
    mass = 100
    
    speedScale = 0.01
    
    randomForceScale = 5

    positionBuffer = []

    position = new Vector3(0,0,0)
    
    velocity = new Vector3(0,0,0)


    tailSections = []

    constructor: (bounds) ->
        @bounds = bounds

        scale = 1

        for i in [0..tailCount]
            section = new SnakeSection(scale)
            tailSections.push(section)
            root.scene.add(section.mesh)
            scale = scale * tailReduction

    update: (delta, frame) =>
        scale = 1
        
        updatePhysics(delta)

        for section,i in tailSections
            section.update(position)
            

    updatePhysics = (delta) ->
        randomForce = new Vector3(((Math.random()-.5)*2)*randomForceScale, ((Math.random()-.5)*2)*randomForceScale, ((Math.random()-.5)*2)*randomForceScale)
        
        forces = [randomForce]
        
        netForce = new Vector3(0,0,0)

        for force in forces
            netForce.add(force)
            
        acceleration = netForce.multiply(1/mass)
        
        newVelocity = acceleration.multiply(delta).add(velocity) ## a*t + v(i) = v(f)

        velocity = newVelocity
        
        position.add(velocity);

class SnakeSection

    vertexRandomScale = 20
    baseGeoSize = 70

    constructor: (inScale) ->
        scale = inScale;

        origVerts = []

        @update = (position) ->
            randomizeVerticies(@mesh.geometry)
            @mesh.position = position

        createMesh = (scale) ->

            geometry = createGeo(scale);
            geometry.dynamic = true

            geometry.computeFaceNormals()
            geometry.computeVertexNormals()

            material = new THREE.MeshLambertMaterial( { color: 0xdddddd, shading: THREE.FlatShading} )

            newMesh = new THREE.Mesh( geometry, material )
            newMesh.rotation.x = Math.random()
            newMesh.rotation.y = Math.random()
            newMesh.rotation.z = Math.random()

            newMesh

        createGeo = (scale) ->
            geometry = new THREE.SphereGeometry( baseGeoSize*scale, 16*scale, 8*scale );
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

        camera.position.z = 400

        root.scene = new THREE.Scene()
        root.scene.fog = new THREE.FogExp2( 0xaaccff, 0.0007 )

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