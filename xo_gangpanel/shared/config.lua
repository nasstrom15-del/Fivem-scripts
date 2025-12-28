Config = {

    takingOverSize = 10.0,
    takeOverTime = 5,
  
    Levels = {
      [1] = { pointsNeeds = 10, maxOrders = 0},
      [2] = { pointsNeeds = 20, maxOrders = 1},
      [3] = { pointsNeeds = 30, maxOrders = 1},
      [4] = { pointsNeeds = 40, maxOrders = 1},
      [5] = { pointsNeeds = 50, maxOrders = 2},
    },
  
    RandomRewards = {
      money = {500, 1500},
      points = {7, 15}
    },
  
    Drugs = {
      SellPrice = {
          weed_packaged = {1000, 2000},
          meth_packaged = {1700, 2300},
          cocaine_packaged = {2000, 2700},
      }
    },
  
    NightMultipler = {
      Time = {23,04},
      Multiplier = {1.2, 2}
    },
  
  
    Selling = {
      TimeBetweenSpawns = {Min = 5, Max = 25},
      PedModels = {"a_m_m_farmer_01", "a_m_m_bevhills_02", "a_m_y_business_01"},
    }
  }

  Config.Reward = {
    ["1"] = {
        Items = {
            {item = "weapon_pistol", quantity = 1}
        },
        Money = "1500",
        Points = "10",
        PointsRequired = "125"
    },
    ["2"] = {
        Items = {
            {item = "weapon_pistol", quantity = 1}
        },
        Money = "1500",
        Points = "10", 
        PointsRequired = "250"
    },
    ["3"] = {
        Items = {
            {item = "weapon_pistol", quantity = 1}
        },
        Money = "1500",
        Points = "10", 
        PointsRequired = "500"
    },
    ["4"] = {
        Items = {
            {item = "weapon_pistol", quantity = 1}
        },
        Money = "1500",
        Points = "10", 
        PointsRequired = "750"
    },
    ["5"] = {
        Items = {
            {item = "weapon_pistol", quantity = 1}
        },
        Money = "1500",
        Points = "10", 
        PointsRequired = "1000"
    },
  }
  
  local basePoints = 10
  local pointsStep = 8
  local increasedPointsStep = 20 
  local finalStretchMultiplier = 10 
  local finalStretchStart = 95 
  local transitionStart = 90 
  
  for i = 6, 100 do
  local isTransition = i >= transitionStart and i < finalStretchStart
  local isFinalStretch = i >= finalStretchStart
  local transitionScale = isTransition and ((i - transitionStart) / (finalStretchStart - transitionStart)) or 0
  local finalStretchScale = isFinalStretch and 1 or 0
  
  local scale = math.max(transitionScale, finalStretchScale)
  
  local pointsIncrease = (i > 3 and increasedPointsStep or pointsStep) + scale * (finalStretchMultiplier - 1) * pointsStep
  local pointsNeeds = basePoints + (i - 1) * pointsIncrease
  
  local maxOrders = math.floor(i / 4)
  
  maxOrders = math.min(30, math.max(1, maxOrders))
  
  Config.Levels[i] = {
    pointsNeeds = pointsNeeds,
    maxOrders = maxOrders,
  }
  end
  
  Config.Blacklisted = {
    "police",
    "ambulance",
    "securitas",
    "cardealer",
    "cardealer2",
    "unemployed",
    "scstyling",
    "autoexperten",
    "mecano",
    "bennys",
    "taxi",
    "nattklubb",
    "moore",
    "dhl",
    "trygghansa",
  }
    
  Config.Zones = {
    {
        name = 'Scenen',
        actions = {
            {
                text = 'Ta över området',
                coords = vector3(712.16, 653.1, 128.91),
                canSell = true,
                Sell = "cocaine_packaged",
                Multiplier = 2.2
            },
        }
    },
    {
      name = 'Methet',
      actions = {
          {
              text = 'Ta över området',
              coords = vector3(1001.0706, -1558.5543, 30.7635),
              
              canSell = false,
              Sell = "cocaine_packaged",
              Multiplier = 1.5,
              canProcess = true,
              processSteps = {
                [1] = {
                      text = 'Koka meth',
                      progress = 'Kokar...',
                      coords = vector3(1029.2684, -1592.6775, 14.8016),
                      markerSize = 1.5,
                      requiredItem = 'chemicals',
                      requiredCount = 2,
                      resultItem = 'meth',
                      resultCount = 1,
                      successMsg = 'Du har kokat meth!',
                      failureMsg = 'Du har inte tillräckligt med råmaterial.'
                  },
                  [2] =  {
                      text = 'Paketera meth',
                      progress = 'Packar...',
                      coords = vector3(1031.5282, -1595.3821, 14.3364),
                      markerSize = 1.5,
                      requiredItem = 'meth',
                      requiredCount = 2,
                      resultItem = 'meth_packaged',
                      resultCount = 1,
                      successMsg = 'Du paketerade meth!',
                      failureMsg = 'Du har inte tillräckligt med bearbetat material.'
                  },
                  [3] =  {
                      text = 'Paketera meth',
                      progress = 'Packar...',
                      coords = vector3(1026.8969, -1595.3818, 14.3364),
                      markerSize = 1.5,
                      requiredItem = 'meth',
                      requiredCount = 2,
                      resultItem = 'meth_packaged',
                      resultCount = 1,
                      successMsg = 'Du paketerade meth!',
                      failureMsg = 'Du har inte tillräckligt med bearbetat material.'
                  }
              }
  
          },
      }
  },
    {
        name = 'Nakenstaden',
        actions = {
            {
                text = 'Ta över området',
                coords = vector3(-1166.0003662109, 4925.630859375, 222.98896789551),
                
                canSell = false,
                Sell = "weed_packaged",
                Multiplier = 1.2
            },
        }
    },
    {
      name = 'Trailerparken',
      actions = {
          {
              text = 'Ta över området',
              coords = vector3(2353.0203, 2579.3054, 46.6676),
              
              canSell = true,
              Sell = "weed_packaged",
              Multiplier = 1.5
          },
      }
  },
    {
        name = 'Bryggan',
        actions = {
            {
                text = 'Ta över området',
                coords = vector3(-270.29177856445, 6629.7778320313, 7.5175285339355),
                
                canSell = false,
                Sell = "weed_packaged",
                Multiplier = 1.0
            },
        }
    },
    {
        name = 'Kärnkraftverket',
        actions = {
            {
                text = 'Ta över området',
                coords = vector3(2725.6508789063, 1477.4389648438, 51.380653381348),
                
                canSell = false,
                Sell = "weed_packaged"
            },
        }
    },
    {
        name = 'Casinot',
        actions = {
            {
                text = 'Ta över området',
                coords = vector3(1262.7471923828, 325.41702270508, 81.990875244141),
                
                canSell = false,
                Sell = "weed_packaged"
            },
        }
    },
    {
        name = 'Tvätten',
        actions = {
            {
                text = 'Ta över området',
                coords = vector3(1104.3778076172, -325.00936889648, 67.151756286621),
                canSell = false,
                Sell = "weed_packaged",
                Multiplier = 2.0
            },
        }
    },
    {
        name = 'Kokainet',
        actions = {
            {
                text = 'Ta över området',
                coords = vector3(775.9584, -146.6105, 75.2085),
                canSell = false,
                Sell = "weed_packaged",
                Multiplier = 1.5,
                canProcess = true,
                processSteps = {
                    [1] =  {
                        text = 'Paketera kokain',
                        progress = 'Packar...',
                        coords = vector3(781.8030, -148.2598, 62.4370),
                        markerSize = 1.5,
                        requiredItem = 'cocaine',
                        requiredCount = 2,
                        resultItem = 'cocaine_packaged',
                        resultCount = 1,
                        successMsg = 'Du paketerade kokain!',
                        failureMsg = 'Du har inte tillräckligt med bearbetat material.'
                    },
                    [2] =  {
                        text = 'Paketera kokain',
                        progress = 'Packar...',
                        coords = vector3(785.4993, -150.3627, 62.4370),
                        markerSize = 1.5,
                        requiredItem = 'cocaine',
                        requiredCount = 2,
                        resultItem = 'cocaine_packaged',
                        resultCount = 1,
                        successMsg = 'Du paketerade kokain!',
                        failureMsg = 'Du har inte tillräckligt med bearbetat material.'
                      },
                      [3] =  {
                          text = 'Paketera kokain',
                          progress = 'Packar...',
                          coords = vector3(786.2844, -144.0156, 62.4370),
                          markerSize = 1.5,
                          requiredItem = 'cocaine',
                          requiredCount = 2,
                          resultItem = 'cocaine_packaged',
                          resultCount = 1,
                          successMsg = 'Du paketerade kokain!',
                          failureMsg = 'Du har inte tillräckligt med bearbetat material.'
                    }
                }
    
            },
        }
    },
    {
        name = 'Vindkraftverket',
        actions = {
            {
                text = 'Ta över området',
                coords = vector3(2263.51171875, 2044.7001953125, 128.63349914551),
                canSell = false,
                Sell = "weed_packaged",
                Multiplier = 1.0
            },
        }
    },
    {
        name = 'Weedet',
        actions = {
            {
                text = 'Ta över området',
                coords = vector3(-34.8886, -2527.2817, 6.0100),
                canSell = true,
                Sell = "weed_packaged",
                Multiplier = 1.5,
                canProcess = true,
                processSteps = {
                  [1] = {
                        text = 'Paketerar Weed',
                        progress = 'Packar...',
                        coords = vector3(-44.7, -2528.36, 6.01),
                        markerSize = 1.5,
                        requiredItem = 'weed',
                        requiredCount = 2,
                        resultItem = 'weed_packaged',
                        resultCount = 10,
                        successMsg = 'Du har kokat cannabis!',
                        failureMsg = 'Du har inte tillräckligt med råmaterial.'
                    }
             
                }
            },
        }
    },
   
    {
        name = 'Sandy',
        actions = {
            {
                text = 'Ta över området',
                coords = vector3(1536.3354492188, 3585.9128417969, 38.766506195068),
                
                canSell = false,
                Multiplier = 1.5,
                Sell = "weed_packaged"
            },
        }
    },
    {
        name = 'Tunnel',
        actions = {
            {
                text = 'Ta över området',
                coords = vector3(16.687473297119, -639.23010253906, 16.088077545166),
                
                canSell = false,
                Sell = "weed_packaged"
            },
        }
    },
    {
        name = 'Hangaren',
        actions = {
            {
                text = 'Ta över området',
                coords = vector3(1728.1309814453, 3322.7497558594, 41.223472595215),
                
                canSell = false,
                Sell = "weed_packaged"
                 -- Multiplier
            },
        }
    },
    {
        name = 'Lägenheterna',
        actions = {
            {
                text = 'Ta över området',
                coords = vector3(553.91296386719, -1776.8723144531, 29.16953086853),
                canSell = true,
                Sell = "meth_packaged",
                Multiplier = 2.0
            },
        }
    },
    {
        name = 'Parkeringshuset',
        actions = {
            {
                text = 'Ta över området',
                coords = vector3(-154.78372192383, -161.51588439941, 43.621238708496),
                
                canSell = false,
                Sell = "weed_packaged"
            },
        }
    },
    {
        name = 'Industrin',
        actions = {
            {
                text = 'Ta över området',
                coords = vector3(513.22528076172, -1949.9622802734, 24.985101699829),
                
                canSell = true,
                Sell = "weed_packaged"
            },
        }
    },
    {
        name = 'Lekparken',
        actions = {
            {
                text = 'Ta över området',
                coords = vector3(-817.2936, 862.9108, 202.9930),
                
                canSell = false,
                Multiplier = 1.5,
                Sell = "weed_packaged"
            },
        }
    },
    {
      name = 'Hotellet',
      actions = {
          {
              text = 'Ta över området',
              coords = vector3(-1197.6943, 336.4796, 70.9091),
              
              canSell = false,
              Sell = "weed_packaged"
          },
      }
  },
  {
      name = 'Labyrinten',
      actions = {
          {
              text = 'Ta över området',
              coords = vector3(-2342.8708, 286.2077, 169.4669),
              
              canSell = false,
              Sell = "weed_packaged"
          },
      }
  },
  {
      name = 'Country Club',
      actions = {
          {
              text = 'Ta över området',
              coords = vector3(-3018.6621, 100.8361, 11.6476),
              
              canSell = false,
              Sell = "weed_packaged"
          },
      }
  },
  {
      name = 'Gränden',
      actions = {
          {
              text = 'Ta över området',
              coords = vector3(-1071.0280, -1670.5715, 4.4453),
              
              canSell = false,
              Sell = "weed_packaged"
          },
      }
  },
  {
      name = 'Ugglan',
      actions = {
          {
              text = 'Ta över området',
              coords = vector3(1580.5266, 2094.9187, 68.9877),
              
              canSell = false,
              Sell = "weed_packaged"
          },
      }
  },
  {
      name = 'Ladan',
      actions = {
          {
              text = 'Ta över området',
              coords = vector3(1946.0201, 4637.6431, 40.5677),
              
              canSell = false,
              Sell = "weed_packaged"
          },
      }
  },
    {
        name = 'Garaget',
        actions = {
            {
                text = 'Ta över området',
                coords = vector3(359.83493041992, -1688.2164306641, 27.304733276367),
                
                canSell = false,
                Sell = "weed_packaged"
                 -- Multiplier
            },
        }
    },
    {
        name = 'Kemikalierna',
        actions = {
            {
                text = 'Ta över området',
                coords = vector3(827.4479, -3211.2834, 5.9008),
                
                canSell = false,
                Sell = "weed_packaged"
            },
        }
    },
    {
      name = 'Cannabisset',
      actions = {
          {
              text = 'Ta över området',
              coords = vector3(1247.5466, 1860.1703, 79.5708),
              
              canSell = false,
              Sell = "weed_packaged"
          },
      }
  },
    {
        name = 'Oljefältet',
        actions = {
            {
                text = 'Ta över området',
                coords = vector3(1564.3048095703, -2165.0002441406, 77.532028198242),
                
                canSell = false,
                Multiplier = 1.5,
                Sell = "weed_packaged"
            },
        }
    },
    {
        name = 'Observatoriumet',
        actions = {
            {
                text = 'Ta över området',
                coords = vector3(-405.7372, 1227.5930, 325.6411),
                
                canSell = false,
                Sell = "weed_packaged"
            },
        }
    },
  }
  
  Config.QuestSettings = {
  
      Ped = {
        'a_m_m_business_01',
        'csb_mp_agent14',
        'cs_chengsr'
      },
  
      Coords = {
        vector3(-651.03, -1752.33, 24.58),
        vector3(-3090.65, 381.53, 4.28),
        vector3(-1634.6, -1092.0, 3.54),
        vector3(1138.94, -1339.15, 34.81),
      },
  }
  
  