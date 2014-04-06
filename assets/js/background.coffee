root = exports ? this

# use randomSeed as frame offset for tail pos

class Snake 
    tailCount = 3
    tailReduction = 0.5
    tailOffset = 200
    maxVelocity = 3

    tailSections = []

    constructor: (bounds) ->
        @bounds = bounds

        scale = 1

        @head = new SnakeSection(scale)
        root.scene.add(@head.mesh)

        for i in [0..tailCount]
            scale = scale * tailReduction
            tailSections.push(new SnakeSection(scale))
            root.scene.add(tailSections.mesh)

    update: (delta, frame) =>
        scale = 1

        @head.update(delta, frame, 0)

        for section,i in tailSections
            section.update(delta, frame, (i+1)*tailOffset)

class SnakeSection

    speedScale = 0.01

    vertexRandomScale = 20
    baseGeoSize = 70

    constructor: (inScale) ->
        scale = inScale;

        origVerts = []

        position = {
            x: 0
            y: 0
            z: 0
        }
        
        velocity = {
            x: 0
            y: 0
            z: 0
        }

        @update = (delta, frame, offset) ->
            # root.scene.remove(@mesh);
            # @mesh = createMesh(scale)

            # root.scene.add(@mesh)
            randomizeVerticies(@mesh.geometry)            

            updateVelocity(frame, offset)
            updatePosition()

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

        updateVelocity = (frame, offset) ->
            randomX = (Math.random(frame+offset+1)*2 - 1) * speedScale;
            randomY = (Math.random(frame+offset+2)*2 - 1) * speedScale;
            randomZ = (Math.random(frame+offset+3)*2 - 1) * speedScale;
            # borderCorrection

            velocity.x = velocity.x + randomX
            velocity.y = velocity.y + randomY
            velocity.z = velocity.z + randomZ


        updatePosition = () =>
            @mesh.position.x = @mesh.position.x + velocity.x
            @mesh.position.y = @mesh.position.y + velocity.y
            @mesh.position.z = @mesh.position.z + velocity.z


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