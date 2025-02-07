PhysicalMaterials = {
  "PM_Concrete",
  "PM_Flesh",
  "PM_Glass", 
  "PM_Grass",
  "PM_Gravel",
  "PM_Ground",
  "PM_Metal",
  "PM_MetalLight",
  "PM_Mud",
  "PM_Plastic",
  "PM_Rock",
  "PM_Rubber",
  "PM_RubberBouncy",
  "PM_Sand",
  "PM_Water",
  "PM_Wood",
  "PM_WoodHeavy"
}



Props = {
  -- 1
  {
    Name = "nanos world",
    Description = "where it all begins",
    Mesh = "nanos-world::SM_Sphere",
    TexturePath = "package://merge/Client/Textures/nanos.png",
    PhysicalMaterial = "PM_Flesh"
  },
  -- 2
  {
    Name = "steve",
    Description = "old and reliable steve", 
    Mesh = "nanos-world::SM_Sphere",
    TexturePath = "package://merge/Client/Textures/steve.jpg",
    PhysicalMaterial = "PM_Flesh"
  },
  -- 3
  {
    Name = "thinking",
    Description = "you really reported this as a bug?",
    Mesh = "nanos-world::SM_Sphere", 
    TexturePath = "package://merge/Client/Textures/thinking.png",
    PhysicalMaterial = "PM_RubberBouncy"
  },
  -- 4
  {
    Name = "Pluto",
    Description = "is pluto that small?",
    Mesh = "nanos-world::SM_Sphere",
    TexturePath = "package://merge/Client/Textures/pluto.jpg",
    PhysicalMaterial = "PM_Rock"
  },
  -- 5
  {
    Name = "doge",
    Description = "wow such merge, very points, much money",
    Mesh = "nanos-world::SM_Sphere",
    TexturePath = "package://merge/Client/Textures/doge.png",
    PhysicalMaterial = "PM_Flesh"
  },
  -- 6
  {
    Name = "pastah",
    Description = "why are you gae",
    Mesh = "nanos-world::SM_Sphere",
    TexturePath = "package://merge/Client/Textures/gae.png",
    PhysicalMaterial = "PM_Flesh"
  },
  -- 7
  {
    Name = "network error",
    Description = "digital insanity, all you gonna see is",
    Mesh = "nanos-world::SM_Sphere",
    Custom = {"Material", "nanos-world::M_Wireframe", "Tint", Color(0, 1, 0, 1), "Emissive", Color(0, 10, 0, 10)},
    PhysicalMaterial = "PM_MetalLight"
  },
  -- 8
  {
    Name = "The Shining",
    Description = "Sometimes I wonder if this was a good idea",
    Mesh = "nanos-world::SM_Sphere",
    Custom = {"Tint", Color(10, 10, 0, 1), "Emissive", Color(10, 10, 0, 10)},
    PhysicalMaterial = "PM_Glass"
  },
  -- 9
  {
    Name = "SYED",
    Description = "SYED PLS FIX",
    Mesh = "nanos-world::SM_Sphere",
    TexturePath = "package://merge/Client/Textures/syed.jpg",
    PhysicalMaterial = "PM_Flesh"
  },
  -- 10
  {
    Name = "Empty Slot",
    Description = "This slot is empty",
    Mesh = "nanos-world::SM_Sphere",
    TexturePath = "nanos-world::T_Default",
    PhysicalMaterial = "PM_Metal"
  },
  -- 11
  {
    Name = "sex",
    Description = "i want to have sex with you",
    Mesh = "nanos-world::SM_Sphere",
    TexturePath = "package://merge/Client/Textures/sex.png",
    PhysicalMaterial = "PM_Rubber"
  },
  -- 12
  {
    Name = "one of us",
    Description = "WAIT WHO IS GOING TO BE NEXT?",
    Mesh = "nanos-world::SM_Sphere",
    Custom = {"Icon", true},
    PhysicalMaterial = "PM_Plastic"
  },
  -- 13
  {
    Name = "Lucy in The Sky With Diamonds",
    Description = "a girl with kaleidoscope eyes",
    Mesh = "nanos-world::SM_Sphere",
    TexturePath = "package://merge/Client/Textures/lsd.png",
    PhysicalMaterial = "PM_Glass",
    Custom = {"ColorBounce", true}
  },
  -- 14
  {
    Name = "ERROR",
    Description = "I'm sorry, I'm sorry, I'm sorry",
    Mesh = "nanos-world::SM_Sphere",
    Custom = {"Material", "nanos-world::M_Default_Translucent_Lit_Depth", "StaticMesh", "nanos-world::SM_Error"},
    PhysicalMaterial = "PM_Concrete"
  },
  -- 15
  {
    Name = "SUSphere",
    Description = "A sphere is a three-dimensional geometric shape that is perfectly round in shape.",
    Mesh = "nanos-world::SM_Cube",
    TexturePath = "package://merge/Client/Textures/sus.png",
    PhysicalMaterial = "PM_Metal"
  },
  -- 16
  {
    Name = "Super Massive Black Hole",
    Description = "that's a lot of mass",
    Mesh = "nanos-world::SM_Sphere",
    Custom = {"BlackHole", true},
    PhysicalMaterial = "PM_MetalLight"
  },
  -- 17
  {
    Name = "Dirac Sea",
    Description = "merge what can be merged, static is dynamic",
    Mesh = "nanos-world::SM_Sphere",
    TexturePath = "package://merge/Client/Textures/dirac.jpg",
    Custom = {"Dirac", true},
    PhysicalMaterial = "PM_Water"
  },
  -- 18
  {
    Name = "Watermelon",
    Description = "The last watermelon",
    Mesh = "nanos-world::SM_Fruit_Watermelon_01",
    PhysicalMaterial = "PM_Rubber"
  },
  -- 19
  {
    Name = "Fashionista Trash Can",
    Description = "Only accepts designer garbage",
    Mesh = "nanos-world::SM_TrashCan",
    TexturePath = "nanos-world::T_TrashCan_Fancy",
    PhysicalMaterial = "PM_Metal"
  },
  -- 20
  {
    Name = "Conspiracy Theorist Antenna",
    Description = "Claims to receive signals from cheese planets",
    Mesh = "nanos-world::SM_Antenna",
    TexturePath = "nanos-world::T_Antenna_Tinfoil",
    PhysicalMaterial = "PM_MetalLight"
  },
  -- 21
  {
    Name = "Depressed Rain Cloud",
    Description = "Rains only on itself",
    Mesh = "nanos-world::SM_Cloud",
    TexturePath = "nanos-world::T_Cloud_Sad",
    PhysicalMaterial = "PM_Water"
  },
  -- 22
  {
    Name = "Stand-up Comedian Book",
    Description = "All its jokes are about bookmarks",
    Mesh = "nanos-world::SM_Book",
    TexturePath = "nanos-world::T_Book_Funny",
    PhysicalMaterial = "PM_Wood"
  },
  -- 23
  {
    Name = "Time-Traveling Sandwich",
    Description = "Always fresh, yet somehow ancient",
    Mesh = "nanos-world::SM_Sandwich",
    TexturePath = "nanos-world::T_Sandwich_Time",
    PhysicalMaterial = "PM_Plastic"
  },
  -- 24
  {
    Name = "Yoga Master Pretzel",
    Description = "Can twist into impossible shapes",
    Mesh = "nanos-world::SM_Pretzel",
    TexturePath = "nanos-world::T_Pretzel_Flex",
    PhysicalMaterial = "PM_Gravel"
  },
  -- 25
  {
    Name = "Existential Crisis Pillow",
    Description = "Wonders if it's really comfortable",
    Mesh = "nanos-world::SM_Pillow",
    TexturePath = "nanos-world::T_Pillow_Deep",
    PhysicalMaterial = "PM_Grass"
  }
}
