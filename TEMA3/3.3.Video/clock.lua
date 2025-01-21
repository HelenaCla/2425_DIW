-- MÓDULOS DE OBS
obs           = obslua

-- VARIABLES GLOBALES DEL SCRIPT
source_name   = ""   -- Nombre de la Fuente de Texto en OBS
time_format   = ""   -- Formato de hora (p.ej. %H:%M:%S)

-----------------------------------------------------------
-- DESCRIPCIÓN DEL SCRIPT
-----------------------------------------------------------
function script_description()
    return "Muestra la hora actual en una fuente de texto de OBS."
end

-----------------------------------------------------------
-- PROPIEDADES (PANEL DE CONFIGURACIÓN DEL SCRIPT)
-----------------------------------------------------------
function script_properties()
    local props = obs.obs_properties_create()
    
    -- Selector de la fuente de texto
    local p = obs.obs_properties_add_list(props, "source_name", "Fuente de Texto",
        obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
    
    -- Rellenar la lista con las fuentes disponibles en la escena
    local sources = obs.obs_enum_sources()
    if sources ~= nil then
        for _, source in ipairs(sources) do
            local name = obs.obs_source_get_name(source)
            obs.obs_property_list_add_string(p, name, name)
        end
    end
    obs.source_list_release(sources)

    -- Campo para definir el formato de hora
    obs.obs_properties_add_text(props, "time_format", "Formato de Hora", obs.OBS_TEXT_DEFAULT)
    
    return props
end

-----------------------------------------------------------
-- VALORES POR DEFECTO
-----------------------------------------------------------
function script_defaults(settings)
    obs.obs_data_set_default_string(settings, "source_name", "Texto - Reloj")
    obs.obs_data_set_default_string(settings, "time_format", "%H:%M:%S")
end

-----------------------------------------------------------
-- CUANDO CAMBIAN AJUSTES
-----------------------------------------------------------
function script_update(settings)
    source_name = obs.obs_data_get_string(settings, "source_name")
    time_format = obs.obs_data_get_string(settings, "time_format")
end

-----------------------------------------------------------
-- FUNCIÓN TICK, SE LLAMA CADA FRAME
-----------------------------------------------------------
function script_tick(seconds)
    -- Obtenemos la fuente de texto
    local source = obs.obs_get_source_by_name(source_name)
    if source ~= nil then
        -- Creamos ajustes temporales para cambiar el texto de la fuente
        local settings = obs.obs_data_create()
        
        -- Actualizamos el texto con la fecha/hora
        local current_time = os.date(time_format)
        obs.obs_data_set_string(settings, "text", "Time: " .. current_time)
        
        -- Aplicamos los ajustes a la fuente
        obs.obs_source_update(source, settings)
        
        -- Liberamos los recursos
        obs.obs_data_release(settings)
        obs.obs_source_release(source)
    end
end
