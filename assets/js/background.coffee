root = exports ? this

# use randomSeed as frame offset for trail pos

class Snake 
    headSize = 70
    trailcount = 5
    trailReduction = 0.5
    trailSpacing = 200
    vertexRandomScale = 2
    maxVelocity = 3
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

    trailGeometries = []
    constructor: (bounds, scene) ->
        @bounds = bounds

        scale = 1

        @head = createMesh(scale)
        scene.add(@head)

        for num,i in [0..trailCount]
            scale = scale*trailReduction
            mesh = createMesh(scale)
            trailGeometries.push(mesh)
            scene.add(mesh)

    update: (delta) =>
        @head.geometry = createGeo(1)



    createMesh = (scale) ->

        geometry = createGeo(scale);
        # geometry.dynamic = true

        # geometry.computeFaceNormals()
        # geometry.computeVertexNormals()

        material = new THREE.MeshLambertMaterial( { color: 0xdddddd, shading: THREE.FlatShading} )

        mesh = new THREE.Mesh( geometry, material )

    createGeo = (scale) ->
        geometry = new THREE.SphereGeometry( headSize*scale, 16*scale, 8*scale );
        randomizeVerticies(geometry)

    randomizeVerticies = (geo) ->
         for vertex,i in geometry.vertices

            vertex.y = vertex.y + vertexRandomScale*(Math.random() - 0.5)
            vertex.x = vertex.x + vertexRandomScale*(Math.random() - 0.5)
            vertex.z = vertex.z + vertexRandomScale*(Math.random() - 0.5)
(->




    container = undefined

    camera = undefined
    scene = undefined
    renderer = undefined

    mesh = undefined
    geometry = undefined
    material = undefined

    time = undefined

    init = ->

        container = document.getElementById( 'container' )

        camera = new THREE.PerspectiveCamera( 60, root.innerWidth / root.innerHeight, 1, 20000 )
        camera.position.z = 400

        scene = new THREE.Scene()
        scene.fog = new THREE.FogExp2( 0xaaccff, 0.0007 )

        geometry = new THREE.SphereGeometry( 70, 16, 8 );
        geometry.dynamic = true

        geometry.computeFaceNormals()
        geometry.computeVertexNormals()

        material = new THREE.MeshLambertMaterial( { color: 0xdddddd, shading: THREE.FlatShading} )

        mesh = new THREE.Mesh( geometry, material )
        scene.add( mesh )

        scene.add( new THREE.AmbientLight( 0x666666 ) );

        directionalLight = new THREE.DirectionalLight( 0xffffff, 1 );

        directionalLight.position.x = -0.1;
        directionalLight.position.y = 0.5;
        directionalLight.position.z = 0.7;

        directionalLight.position.normalize();

        scene.add( directionalLight );

        renderer = new THREE.WebGLRenderer()
        renderer.setClearColor( 0xffffff, 1 )
        renderer.setSize( root.innerWidth, root.innerHeight )

        container.innerHTML = ""

        container.appendChild( renderer.domElement )

        root.addEventListener( 'resize', onWindowResize, false )

     onWindowResize = -> 
        camera.aspect = root.innerWidth / root.innerHeight
        camera.updateProjectionMatrix()

        renderer.setSize( root.innerWidth, root.innerHeight )

    animate = ->

        requestAnimationFrame( animate )
        render()

    render = ->

        delta = clock.getDelta()
        time = clock.getElapsedTime() * 10

        # for ( var i = 0, l = geometry.vertices.length i < l i ++ ) {

        #     geometry.vertices[ i ].y = 35 * Math.sin( i / 5 + ( time + i ) / 7 )

        # }

        randomizeVerticies(mesh.geometry)

        mesh.geometry.verticesNeedUpdate = true
        renderer.render( scene, camera )

    worldWidth = 128
    worldDepth = 128
    worldHalfWidth = worldWidth / 2
    worldHalfDepth = worldDepth / 2

    clock = new THREE.Clock()

    init()
    animate()

)()