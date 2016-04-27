local function DEFAULT_STYLE()
return {
    ['2d'] = {
        style = 'polygon',
        face = {
            color = '0xff00ff00',
            enable_alpha = true,
            texture = nil, -- 纹理路径
            automatic_scale = nil, -- 是否自动缩放
            texture_rotation = 0, -- texture旋转角度[-360,360],顺时针为正
            edge_aligment = true -- 如果为矩形,texture旋转时自动与边对齐
        },
        outline = {
            color = '0xffc0c0c0',
            width = 0.02,
            enable_alpha = false,
        },
        left_side = {}
    }
}
end

local function DEFAULT_3D_STYLE()
return{
    ['2d'] = {
        style = 'polygon',
        face = {
            color = '0xffe1e9ef',
            enable_alpha = false,
            texture = null,
            automatic_scale = null
        },
        outline = {
            color = '0xffc0c0c0',
            width = 0.02,
            enable_alpha = false,
        },
        left_side = {}
    },
    ['3d'] = {
        style = 'polygon',
        face_on_bottom = false, --为false时 height才有效
        height = 2, --如果多边形有面的话，要和outline的高度相同
        face = {
            color = '0Xfffff5ee',
            --color = '0xffe1e9ef',
            enable_alpha = false
        },
        outline = {
            color = '0XFF000000',
            width = 0.05,
            height = 2,
            enable_alpha=false,
            left_side = {
                color = '0XFFeed3c1',
                enable_alpha = false
            },
            right_side = {
                color = '0XFFeed3c1',
                enable_alpha = false
            },
            top_side = {
                color = '0XFF000000',
                enable_alpha = false
            }
        }
    }
}
end


local function GET_FONT_PATH()

local engine = GetEngine()
local properties = engine.properties
local os = properties["os"]

if os >= "iOS/7.0" and os < "iOS/8.0" then
return "/System/Library/Fonts/Cache/STHeiti-Light.ttc"
elseif os >= "iOS/8.0" and os < "iOS/9.0" then
return "/System/Library/Fonts/Core/STHeiti-Light.ttc"
elseif os >= "iOS/9.0" then
return "/System/Library/Fonts/LanguageSupport/PingFang.ttc"
else
return "/System/Library/Fonts/LanguageSupport/PingFang.ttc"
end

end

local function SetImageWith( imageName,needTiled ,angle, needAligment)
  -- body
  return{
         ['2d'] = {
               style = 'polygon',
               face = {
                  
                   enable_alpha = false,
                   texture = imageName,
                   automatic_scale = needTiled,
                   texture_rotation = angle,
                   edge_aligment =  needAligment,
               },
               outline = {
                   color = '0xffababab',
                   width = 0.03,
                   enable_alpha = false,
               },
               left_side = {}
           }
           
           
       }
end

local function DEFAULT_3D_STYLE(a,height)
return{
    ['2d'] = {
        style = 'polygon',
        face = {
            color = '0xffe1e9ef',
            enable_alpha = false,
            texture = null,
            automatic_scale = null
        },
        outline = {
            color = '0xffc0c0c0',
            width = 0.02,
            enable_alpha = false,
        },
        left_side = {}
    },
    ['3d'] = {
        style = 'polygon',
        face_on_bottom = false, --为false时 height才有效
        height = d, --如果多边形有面的话，要和outline的高度相同
        face = {
            --color = '0xffe1e9ef',
            color = '0Xfffff5ee',
            enable_alpha = false
        },
        outline = {
            color = '0XFF000000',
            width = 0.05,
            height = height,
            enable_alpha=false,
            left_side = {
                color = '0XFFeed3c1',
                --color = '0xffe1e9ef',
                
                enable_alpha = false
            },
            right_side = {
                color = '0XFFeed3c1',
                --color = '0xffe1e9ef',
                enable_alpha = false
            },
            top_side = {
                color = '0XFFffffff',
                enable_alpha = false
            }
        }
    }
}
end

local function COLOR_STYLE(a, b, c)
style = DEFAULT_STYLE()
style['2d'].face.color = a;
style['2d'].face.enable_alpha = false;
style['2d'].outline.color = b or '0xFFc0c0c0';
style['2d'].outline.width = c or 0.02;
style['2d'].outline.enable_alpha = false;
return style
end

local function COLOR_3D_STYLE(a,b,c,height)
style = DEFAULT_3D_STYLE(a,height)
--style = DEFAULT_3D_STYLE()
style['2d'].face.color = a;
style['2d'].face.enable_alpha = false;
style['2d'].outline.color = b or '0xFFc0c0c0';
style['2d'].outline.width = c or 0.02;
style['2d'].outline.enable_alpha = false;
return style
end



local function TEXTURE_1_STYLE(a, b, c)
style = DEFAULT_STYLE()
style['2d'].face.color = null;
style['2d'].face.enable_alpha = true;
style['2d'].face.texture = a;
style['2d'].outline.color = b or '0xff7D7D7D';
style['2d'].face.automatic_scale = true;
style['2d'].outline.width = c or 0.1;
return style
end

local function TEXTURE_2_STYLE(a, b, c)
style = DEFAULT_STYLE()
style['2d'].face.color = null;
style['2d'].face.enable_alpha = true;
style['2d'].face.texture = a;
style['2d'].outline.color = b or '0xff7D7D7D';
style['2d'].face.automatic_scale = false;
style['2d'].outline.width = c or 0.1;
return style
end

local function DEFAULT_ICON()
return {
    ['2d'] = {
        style = 'icon',
        icon = "00000000.png",
        use_texture_origin_size = false,
        width = 30,
        height = 30,
        anchor_x = 0.5,
        anchor_y = 0.5
    }
}
end

local function ICON(a)
return {
    ['2d'] = {
        style = 'icon',
        icon = a,
        use_texture_origin_size = false,
        width = 30,
        height = 30,
    }
}
end

CONFIG = {
    views = {
        default = {
            layers = {
                Frame = {
                    height_offset = 0.1,
                    renderer = {
                        type = 'simple',
                        ['2d'] = {
                            style = 'polygon',
                            face = {
                                color = '0xfff5f5f5',--路
                                enable_alpha = false
                            },
                            outline = {
                                color = '0xffC0C0C0',
                                width = 0.05,
                                enable_alpha = false,
                            },
                            left_side = {}
                        },
                        
                    }
                },
               
               Area = {
                   height_offset = 0,
                   renderer = {
                       type = 'unique',
                       key = {
                           'id',
                           'category',
                       },
                       default = DEFAULT_STYLE(),

                       styles = {
                            
                            [665537] = SetImageWith('xiaofangzi.png',false,1,true),
                            [665551] = SetImageWith('xiaofangzi.png',false,1,true),
                            [684544] = SetImageWith('wuding.png',false,0,true),
                            [684543] = SetImageWith('mumianjiudian.png',false,0,true),
                            [684542] = SetImageWith('putijiudian.png',false,0,true),
                            [665520] = SetImageWith('caoping.png',false,0,true),
                       },
                   }
               },
                Area_text = {
                    collision_detection = true,
                    font_path = GET_FONT_PATH(),
                    renderer = {
                        type = 'simple',
                        ['2d'] = {
                            style = 'annotation',
                            color = '0xFF696969',
                            field = 'name',
                            size = 30,
                            outline_color = '0xFF000000',
                            outline_width = 0,
                            anchor_x = 0.5,
                            anchor_y = 0.5,
                            aabbox_extend = 10,
                        },
                    }
                },
                Facility = {
                    height_offset = -0.2;
                    collision_detection = true,
                    renderer = {
                        type = 'unique',
                        key = {
                            'category'
                        },
                        default = DEFAULT_ICON(),
                        styles = {
                            [11000000] = ICON('11000000.png'),
                            [11401000] = ICON('11401000.png'),
                            [11454000] = ICON('11454000.png'),
                            [13076000] = ICON('13076000.png'),
                            [13113000] = ICON('13113000.png'),
                            [13116000] = ICON('13116000.png'),
                            [15001000] = ICON('15001000.png'),
                            [15002000] = ICON('15002000.png'),
                            [15026000] = ICON('15026000.png'),
                            [15043000] = ICON('15043000.png'),
                            [15044000] = ICON('15044000.png'),
                            [17001000] = ICON('17001000.png'),
                            [17004000] = ICON('17004000.png'),
                            [17006000] = ICON('17006000.png'),
                            [17007000] = ICON('17007000.png'),
                            [17008000] = ICON('17008000.png'),
                            [21048000] = ICON('21048000.png'),
                            [21049000] = ICON('21049000.png'),
                            [22011000] = ICON('22011000.png'),
                            [22012000] = ICON('22012000.png'),
                            [22014000] = ICON('22014000.png'),
                            [22015000] = ICON('22015000.png'),
                            [22016000] = ICON('22016000.png'),
                            [22017000] = ICON('22017000.png'),
                            [22019000] = ICON('22019000.png'),
                            [22021000] = ICON('22021000.png'),
                            [22022000] = ICON('22022000.png'),
                            [22023000] = ICON('22023000.png'),
                            [22033000] = ICON('22033000.png'),
                            [22039000] = ICON('22039000.png'),
                            [22040000] = ICON('22040000.png'),
                            [22052000] = ICON('22052000.png'),
                            [22053000] = ICON('22053000.png'),
                            [22054000] = ICON('22054000.png'),
                            [22055000] = ICON('22055000.png'),
                            [23004000] = ICON('23004000.png'),
                            [23005000] = ICON('23005000.png'),
                            [23007000] = ICON('23007000.png'),
                            [23008000] = ICON('23008000.png'),
                            [23009000] = ICON('23009000.png'),
                            [23010000] = ICON('23010000.png'),
                            [23011000] = ICON('23011000.png'),
                            [23012000] = ICON('23012000.png'),
                            [23013000] = ICON('23013000.png'),
                            [23014000] = ICON('23014000.png'),
                            [23015000] = ICON('23015000.png'),
                            [23016000] = ICON('23016000.png'),
                            [23017000] = ICON('23017000.png'),
                            [23018000] = ICON('23018000.png'),
                            [23019000] = ICON('23019000.png'),
                            [23020000] = ICON('23020000.png'),
                            [23021000] = ICON('23021000.png'),
                            [23022000] = ICON('23022000.png'),
                            [23023000] = ICON('23023000.png'),
                            [23024000] = ICON('23024000.png'),
                            [23025000] = ICON('23025000.png'),
                            [23026000] = ICON('23026000.png'),
                            [23027000] = ICON('23027000.png'),
                            [23028000] = ICON('23028000.png'),
                            [23029000] = ICON('23029000.png'),
                            [23030000] = ICON('23030000.png'),
                            [23031000] = ICON('23031000.png'),
                            [23032000] = ICON('23032000.png'),
                            [23033000] = ICON('23033000.png'),
                            [23034000] = ICON('23034000.png'),
                            [23035000] = ICON('23035000.png'),
                            [23036000] = ICON('23036000.png'),
                            [23037000] = ICON('23037000.png'),
                            [23038000] = ICON('23038000.png'),
                            [23039000] = ICON('23039000.png'),
                            [23040000] = ICON('23040000.png'),
                            [23041000] = ICON('23041000.png'),
                            [23042000] = ICON('23042000.png'),
                            [23059000] = ICON('23059000.png'),
                            [23060000] = ICON('23060000.png'),
                            [23061000] = ICON('23061000.png'),
                            [24003000] = ICON('24003000.png'),
                            [24006000] = ICON('24006000.png'),
                            [24014000] = ICON('24014000.png'),
                            [24091000] = ICON('24091000.png'),
                            [24092000] = ICON('24092000.png'),
                            [24093000] = ICON('24093000.png'),
                            [24094000] = ICON('24094000.png'),
                            [24097000] = ICON('24097000.png'),
                            [24098000] = ICON('24098000.png'),
                            [24099000] = ICON('24099000.png'),
                            [24100000] = ICON('24100000.png'),
                            [24111000] = ICON('24111000.png'),
                            [24112000] = ICON('24112000.png'),
                            [24113000] = ICON('24113000.png'),
                            [24114000] = ICON('24114000.png'),
                            [24115000] = ICON('24115000.png'),
                            [24116000] = ICON('24116000.png'),
                            [24117000] = ICON('24117000.png'),
                            [24118000] = ICON('24118000.png'),
                            [24119000] = ICON('24119000.png'),
                            [24120000] = ICON('24120000.png'),
                            [24121000] = ICON('24121000.png'),
                            [24141000] = ICON('24141000.png'),
                            [24142000] = ICON('24142000.png'),
                            [24151000] = ICON('24151000.png'),
                            [24152000] = ICON('24152000.png'),
                            [24161000] = ICON('24161000.png'),
                            [24162000] = ICON('24162000.png'),
                            [24163000] = ICON('24163000.png'),
                            [34001000] = ICON('34001000.png'),
                            [34002000] = ICON('34002000.png'),
                            [35001000] = ICON('35001000.png'),
                            [23043000] = ICON('23043000.png'),
                        }
                    }
                },
                positioning = {
                    height_offset = - 0.4,
                    renderer = {
                        type = 'simple',
                        ['2d'] = {
                            style = 'icon',
                            --              style = 'color_point',
                            --              color = '0xFF006699',
                            icon = 'mapping/location.png',
                            enable_alpha = true,
                            --              size = 3,
                        },
                    }
                },
                navigate = {
                    height_offset = - 0.3,
                    renderer = {
                        type = 'simple',
                        ['2d'] = {
                            style = 'linestring',
                            color = '0xFFf77171',
                            line_style = 'SOLID',
                            enable_alpha = true,
                            width = 2,
                            has_start=true,
                            has_end=true,
                            has_arrow=true,
                            automatic_scale = true, -- 导航线自适应地图大小
                        },
                    }
                }
            }
        }
    }
}


