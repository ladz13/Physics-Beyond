function love.load()
  if arg[#arg] == "-debug" then
    require("mobdebug").start()
  end
  
  love.window.setTitle("Particle Motion")
  love.graphics.setBackgroundColor(1,1,1)
  love.physics.setMeter(128)
  love.window.setMode(900,600)
  World = love.physics.newWorld(0,9.81,true)
  
  alpha = 1
  
  fx = 2
  fy = -3
  a = 1
  gameState = 1
  time = 0
  state = 0
  
  points = {}
  points.x = {}
  points.y = {}
  
  objects = {}
  objects.particle = {}
  objects.particle.body = love.physics.newBody(World,50,550,"dynamic")
  objects.particle.shape = love.physics.newCircleShape(10)
  objects.particle.fixture = love.physics.newFixture(objects.particle.body, objects.particle.shape, 1)
end
function love.update(dt)
  time = time + dt
  if (time > 5 and time < 12) then
    gameState = 2
  elseif (time > 14) then
    gameState = 3
  end
  if (gameState == 1) then
    objects.particle.body:setPosition(50,550)
  elseif (gameState == 2) then
    World:update(dt)
    x = objects.particle.body:getX()
    y = objects.particle.body:getY()
    if (x < 300 and y > 150 and state ~= 3) then
      state = 1
    elseif (x > 300 and x < 400 and y > 150 and y < 400 and state ~= 3) then
      state = 2
    elseif (x < 450 and x > 300 ) then
      state = 3
    elseif (x > 450 and x < 600) then
      state = 4
    elseif (x > 600 and y > 0) then
      state = 5
    elseif (y < 0) then
      state = 6
    end
    if (state == 1) then
      objects.particle.body:applyForce(fx,fy)
      if (fx > 0) then
        fx = fx - 0.025
      end
      fy = fy + 0.025
    elseif ( state == 2) then
      fx = fx - 0.01
      if (fy < 0.5) then
        fy = fy + 0.001
      end
      objects.particle.body:applyForce(fx,fy)
    elseif (state == 3) then
      if (x > 350 and y < 450 and fx > -4 and a == 1) then
        fx = fx - 1
      elseif (x < 350 and y < 600 and y > 300) then
        fx = fx + 0.3
        a = 2
      elseif (x > 400 and y < 300) then
        fx = fx + 0.1
        a = 2
      end
      if (y < 400 and fy > -3.5) then
        fy = fy - 1.5
      elseif (y > 400 and fy > -6) then
        fy = fy - 1
      end
      objects.particle.body:applyForce(fx,fy)
    elseif (state == 4) then
      fx = fx - 0.5
      fy = fy + 8
      objects.particle.body:applyForce(fx,fy)
    elseif (state == 5) then
      fx = fx - 0.5
      fy = fy - 30
      objects.particle.body:applyForce(fx,fy)
    elseif (state == 6) then
      fx = 0
      fy = 0
    end
  end
end
function love.draw()
  love.graphics.setColor(0,0,0)
  myFont = love.graphics.newFont(40)
  love.graphics.setFont(myFont)
  if (gameState == 1) then
    love.graphics.line(65,550,65,535)
    love.graphics.line(65,550,80,550)
    love.graphics.arc("line","open",135,620,100,math.pi+math.pi/4,math.pi+math.pi/2,10000)
    myFont = love.graphics.newFont(20)
    love.graphics.setFont(myFont)
    love.graphics.printf("Particle",125,510,100,"center")
    myFont = love.graphics.newFont(40)
    love.graphics.setFont(myFont)
    love.graphics.printf("Particle Motion Simulation",100,50,700,"center")
    love.graphics.circle("fill", objects.particle.body:getX(), objects.particle.body:getY(), objects.particle.shape:getRadius())
  elseif (gameState == 2) then
    if (alpha > 0) then
      alpha = alpha - 0.01
    end
    love.graphics.setColor(0,0,0,alpha)
    love.graphics.line(65,550,65,535)
    love.graphics.line(65,550,80,550)
    love.graphics.arc("line","open",135,620,100,math.pi+math.pi/4,math.pi+math.pi/2,10000)
    myFont = love.graphics.newFont(20)
    love.graphics.setFont(myFont)
    love.graphics.printf("Particle",125,510,100,"center")
    myFont = love.graphics.newFont(40)
    love.graphics.setFont(myFont)
    love.graphics.printf("Particle Motion Simulation",100,50,700,"center")
    love.graphics.setColor(0,0,0)
    if (state ~= 6) then
      love.graphics.circle("fill", objects.particle.body:getX(), objects.particle.body:getY(), objects.particle.shape:getRadius())
    end
    points.x,points.y,length = love.trail(points.x,points.y,x,y)
  elseif (gameState == 3) then
    points.x,points.y,length = love.trail(points.x,points.y,x,y)
    if (alpha < 1) then
      alpha = alpha + 0.01
    end
    love.graphics.setColor(0,0,0,alpha)
    myFont = love.graphics.newFont(20)
    love.graphics.setFont(myFont)
    love.graphics.printf("O",100,550,50,"center")
    love.graphics.line(100,550,280,210)
    love.graphics.line(100,550,315,230)
    love.graphics.line(270,215,280,210,283,220)
    love.graphics.line(305,232,315,230,315,240)
    love.graphics.printf("x(t)",270,180,50,"center")
    love.graphics.printf("x(t+  t)",330,220,80,"center")
    love.graphics.polygon("line",385,228,380,238,390,238)
    love.graphics.line(285,215,310,225)
    love.graphics.line(290,225,285,215,295,213)
    love.graphics.line(305,230,310,225,305,217)
    love.graphics.polygon("line",318,208,313,218,323,218)
    love.graphics.printf(" x",300,200,50,"center")
    love.graphics.line(280,180,295,180,287,175)
    love.graphics.line(335,220,350,220,342,215)
    love.graphics.line(310,200,325,200,317,195)
    love.graphics.line(790,95,802,90,803,103)
    love.graphics.printf("x",810,105,30,"center")
    love.graphics.line(820,105,835,105,830,100)
    love.graphics.line(500,400,550,400)
    love.graphics.line(600,400,800,400)
    myFont = love.graphics.newFont(30)
    love.graphics.setFont(myFont)
    love.graphics.setFont(myFont)
    love.graphics.printf("=",550,380,50,"center")
    love.graphics.printf("x",500,350,50,"center")
    love.graphics.printf("t",500,410,50,"center")
    love.graphics.printf("t",600,410,200,"center")
    love.graphics.printf("x(t +  t) - x(t)",575,350,250,"center")
    love.graphics.polygon("line",490,380,510,380,500,360)
    love.graphics.polygon("line",500,440,510,420,520,440)
    love.graphics.polygon("line",670,440,680,420,690,440)
    love.graphics.polygon("line",670,380,680,360,690,380)
    love.graphics.line(520,350,535,350,530,345)
    love.graphics.line(600,350,615,350,610,345)
    love.graphics.line(750,350,765,350,760,345)
  end
  end
function love.trail(pointsx,pointsy,x,y)
  length = table.getn(pointsx)
  table.insert(pointsx,x)
  table.insert(pointsy,y)
  i = 1
  while (i <= length and pointsy[i+1] > 0) do
    love.graphics.line(pointsx[i],pointsy[i],pointsx[i+1],pointsy[i+1])
    i = i + 1
  end
  return pointsx,pointsy,length
end
