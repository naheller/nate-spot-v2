function Meta(meta)
    local tags = ""

    if meta.tags and #meta.tags > 0 then
        local tags_list = {}

        -- Need to stringify tag values since they are "Inline" Pandoc AST elements
        for i, tag in ipairs(meta.tags) do
            local tag_string = pandoc.utils.stringify(tag)
            tags_list[i] = tag_string
        end

        local tags_list_concat = table.concat(tags_list, ",")
        tags = pandoc.utils.stringify(tags_list_concat)
    end

    -- Must write out tags even if empty so output array in build script lines up
    io.write(tags .. "\n")
    return meta
end

-- Convert internal links to .html
function Link(el)
    -- If external link, open in new window and add arrow symbol
    -- Else if internal link, slugify and add leading slash
    if string.match(el.target, "^http") then
        el.attributes.target = "_blank"
        -- el.content = pandoc.utils.stringify(el.content) .. utf8.char(0x2197)
    else
        local slug = slugify(pandoc.utils.stringify(el.content))
        el.target = "/" .. slug
    end

    return el
end

-- Keep track of images so we don't lazy load the first one
local image_count = 0

function Image(img)
    -- local source_dir = os.getenv("PANDOC_SOURCE")

    -- Need to add leading slash to image path, since Obsidian does not do this
    img.src = "/" .. img.src

    image_count = image_count + 1

    if image_count > 1 then
        -- Enable lazy loading and async decoding
        img.attributes.loading = "lazy"
        img.attributes.decoding = "async"
    end

    return img
end

function Pandoc(doc)
    local excerpt = ""

    for _, el in ipairs(doc.blocks) do
        if el.t == "Para" then
            local words = {}

            for _, inline in ipairs(el.content) do
                if inline.t == "Str" then
                    table.insert(words, inline.text)
                elseif inline.t == "Link" then
                    local text = pandoc.utils.stringify(inline.content)
                    table.insert(words, text)
                end
            end

            excerpt = table.concat(words, " ")
            break
        end
    end

    io.write(excerpt .. "\n")
    return doc
end

function slugify(str)
    str = str:lower()
    str = str:gsub("['’]", "") -- remove apostrophes
    str = str:gsub("[^a-z0-9]+", "-") -- replace non-alphanumerics with hyphens
    str = str:gsub("^-+", ""):gsub("-+$", "") -- trim leading/trailing hyphens

    return str
end
