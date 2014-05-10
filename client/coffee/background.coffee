root = exports ? this

cubeCount = 15
cubeSize = 40
fieldRadius = 600

class CubeField
    
    
    cubes = []
    
    constructor: () ->
        
        for i in [0..cubeCount]
            t = Math.random()*Math.PI
            s = Math.random()*Math.PI*2
            x = (fieldRadius-50) * Math.sin(t) * Math.cos(s) 
            y = (fieldRadius-50) * Math.sin(t) * Math.sin(s)
            z = (fieldRadius-50) * Math.cos(t)
            
            randomPosition = new CANNON.Vec3(x,y,z)
            #randomPosition = new CANNON.Vec3( ((Math.random()-.5)*2)*fieldRadius, ((Math.random()-.5)*2)*fieldRadius, ((Math.random()-.5)*2)*fieldRadius)
            
            cubes.push(new Cube(randomPosition, fieldRadius))
        
        @update =  (timeStep) ->
            for cube in cubes
                cube.update(timeStep)
        

class Cube
    spinSpeed = .05
    
    randomForceScale = 100
    boundaryForceScale = 50
    
    worldRadius = undefined
    
    constructor: (position, boundsRadius) ->
        worldRadius = boundsRadius
    
        geometry = new THREE.CubeGeometry( cubeSize, cubeSize, cubeSize )
        material = new THREE.MeshLambertMaterial( { color: 0xdddddd, shading: THREE.FlatShading} )
        
        @mesh = new THREE.Mesh( geometry, material )
        
        position.copy(@mesh.position)
        
        root.scene.add( @mesh )
        
        shape = new CANNON.Box(new CANNON.Vec3(cubeSize/2,cubeSize/2,cubeSize/2))
        mass = 50
        @body = new CANNON.RigidBody(mass,shape)
        @body.angularVelocity.set(((Math.random()-.5)*2)*spinSpeed,((Math.random()-.5)*2)*spinSpeed,((Math.random()-.5)*2)*spinSpeed)
        @body.angularDamping = 0
        #@body.linearDamping = 0
        
        @body.position = position
        
        root.world.add(@body)
        
        updateForces = -> 
            randomForce = new CANNON.Vec3(((Math.random()-.5)*2)*randomForceScale, ((Math.random()-.5)*2)*randomForceScale, ((Math.random()-.5)*2)*randomForceScale)
        
            boundaryForce = getBoundaryForce()
    
            forces = [randomForce, boundaryForce]
            
            netForce = new CANNON.Vec3(0,0,0)
    
            for force in forces
                netForce = netForce.vadd(force)
            
            netForce
            
        getBoundaryForce = =>
            boundaryForce = new CANNON.Vec3(0,0,0)
            
            distanceFromOrigin = @body.position.distanceTo(boundaryForce)
    
    
            if distanceFromOrigin > fieldRadius
                pos = position.copy()
                pos.normalize()
                boundaryForce = pos.mult(-1*boundaryForceScale)
    
            boundaryForce
        
        @update = (timeStep) ->
            root.world.step(timeStep)
            
            force = updateForces()
            
            worldPoint = new CANNON.Vec3(0,0,0)
            #force = new CANNON.Vec3(500,0,0)
            @body.applyForce(force, @body.position)
            
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
        renderer = new THREE.WebGLRenderer({ antialias: true })
        renderer.setClearColor( 0xedf7f2, 1 )
        renderer.setSize( root.innerWidth, root.innerHeight )

        container = document.getElementById( 'container' )

        camera = new THREE.PerspectiveCamera( 60, root.innerWidth / root.innerHeight, 1, 20000 )
        container.innerHTML = ""

        container.appendChild( renderer.domElement )

        root.addEventListener( 'resize', onWindowResize, false )

        camera.position.z = 800

        root.scene = new THREE.Scene()
        root.scene.fog = new THREE.FogExp2( 0xedf7f2, 0.002  )

        root.scene.add( new THREE.AmbientLight( 0x666666 ) )

        directionalLight = new THREE.DirectionalLight( 0xedf7f2, 1 )

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
        stats.domElement.style.top = '200px'
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
        root.world.solver.iterations = 3
          

    worldWidth = 128
    worldDepth = 128
    worldHalfWidth = worldWidth / 2
    worldHalfDepth = worldDepth / 2

    clock = new THREE.Clock()

    init()
    animate()
 
)()