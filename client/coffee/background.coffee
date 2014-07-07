root = exports ? this

(->
    container = undefined

    camera = undefined
    root.scene = undefined
    renderer = undefined
    
    root.world = undefined
    
    mesh = undefined
    geometry = undefined

    time = undefined
    frame = 0
    timeStep = 1/60


    init = ->
        renderer = new THREE.WebGLRenderer({ antialias: true })
        renderer.setClearColor( 0xedf7f2, 1 )
        renderer.setSize( root.innerWidth, root.innerHeight )

        container = document.getElementById( 'container' )

        camera = new THREE.PerspectiveCamera( 60, root.innerWidth / root.innerHeight, 1, 20000 )
        container.innerHTML = ""

        container.appendChild( renderer.domElement )

        root.addEventListener( 'resize', onWindowResize, false )

        camera.position.y = 400
        camera.rotation.x = -(Math.PI / 3)

        root.scene = new THREE.Scene()
        root.scene.fog = new THREE.FogExp2( 0xedf7f2, 0.004  )

        # root.scene.add( new THREE.AmbientLight( 0x666666 ) )

        geometry = new THREE.PlaneGeometry( 2000, 2000, 40, 40 )
        geometry.applyMatrix( new THREE.Matrix4().makeRotationX( - Math.PI / 2 ) )
        geometry.dynamic = true

        for vert, i in geometry.vertices
            vert.y = 35 * Math.sin( i/2 )

        geometry.computeFaceNormals()
        geometry.computeVertexNormals()

        material = new THREE.MeshLambertMaterial( { color: 0x000000, wireframe: true } )

        mesh = new THREE.Mesh( geometry, material )
        root.scene.add( mesh )

     onWindowResize = -> 
        camera.aspect = root.innerWidth / root.innerHeight
        camera.updateProjectionMatrix()

        renderer.setSize( root.innerWidth, root.innerHeight )

    animate = ->
        requestAnimationFrame( animate )
        render()

    render = ->

        frame++
        delta = clock.getDelta()
        time = clock.getElapsedTime() * 10

        for vert, i in geometry.vertices 
            vert.y = 35 * Math.sin( i / 5 + ( time + i ) / 7 )
        
        # geometry.computeFaceNormals()
        # geometry.computeVertexNormals()

        mesh.geometry.verticesNeedUpdate = true
        # mesh.geometry.normalsNeedUpdate = true

        renderer.render( root.scene, camera )
          

    worldWidth = 128
    worldDepth = 128
    worldHalfWidth = worldWidth / 2
    worldHalfDepth = worldDepth / 2

    clock = new THREE.Clock()

#    init()
#    animate()
 
)()