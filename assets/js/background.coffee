root = exports ? this

## use randomSeed as frame offset for tail pos

class CubeField

    cubeCount = 15
    cubeSize = 20
    
    fieldRadius = 400
    
    cubes = []
    
    constructor: () ->
        
        for i in [0..cubeCount]
            
            randomPosition = new CANNON.Vec3( ((Math.random()-.5)*2)*fieldRadius, ((Math.random()-.5)*2)*fieldRadius, ((Math.random()-.5)*2)*fieldRadius);
            
            cubes.push(new Cube(randomPosition))
        
        @update =  (timeStep) ->
            for cube in cubes
                cube.update(timeStep);
        

class Cube

    cubeSize = 20
    spinSpeed = 10
    
    constructor: (position) ->
    
        geometry = new THREE.CubeGeometry( cubeSize, cubeSize, cubeSize )
        material = new THREE.MeshBasicMaterial( { color: 0xff0000, wireframe: true } )
        
        @mesh = new THREE.Mesh( geometry, material )
        
        position.copy(@mesh.position)
        
        root.scene.add( @mesh )
        
        shape = new CANNON.Box(new CANNON.Vec3(1,1,1))
        mass = 1
        @body = new CANNON.RigidBody(mass,shape)
        @body.angularVelocity.set(((Math.random()-.5)*2)*spinSpeed,((Math.random()-.5)*2)*spinSpeed,((Math.random()-.5)*2)*spinSpeed)
        @body.linearDamping = @body.angularDamping = 0.5
        
        @body.position = position
        
        root.world.add(@body)
        
        @update = (timeStep) ->
            root.world.step(timeStep)
            
            #worldPoint = new CANNON.Vec3(0,0,0)
            #force = new CANNON.Vec3(500,0,0)
            #@body.applyForce(force, worldPoint)
            
            ## Copy coordinates from Cannon.js to Three.js
            @body.position.copy(@mesh.position)
            @body.quaternion.copy(@mesh.quaternion)
            
        @
        


(->
    container = undefined

    camera = undefined
    root.scene = undefined
    renderer = undefined
    
    root.world = undefined
    
    cubeField = undefined

    time = undefined
    frame = 0
    timeStep = 1/60


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

        camera.position.z = 800

        root.scene = new THREE.Scene()
        root.scene.fog = new THREE.FogExp2( 0xffffff, 0.002  )

        root.scene.add( new THREE.AmbientLight( 0x666666 ) )

        directionalLight = new THREE.DirectionalLight( 0xffffff, 1 )

        directionalLight.position.x = -0.1
        directionalLight.position.y = 0.5
        directionalLight.position.z = 0.7

        directionalLight.position.normalize()

        root.scene.add( directionalLight )

        initCannon()
        
        cubeField = new CubeField()

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
        cubeField.update()
        render()

        stats.update()

    render = ->

        frame++
        delta = clock.getDelta()
        time = clock.getElapsedTime() * 10


        renderer.render( root.scene, camera )
        
    initCannon = ->
        root.world = new CANNON.World()
        root.world.gravity.set(0,0,0)
        root.world.broadphase = new CANNON.NaiveBroadphase()
        root.world.solver.iterations = 10
          

    worldWidth = 128
    worldDepth = 128
    worldHalfWidth = worldWidth / 2
    worldHalfDepth = worldDepth / 2

    clock = new THREE.Clock()

    init()
    animate()
 
)()