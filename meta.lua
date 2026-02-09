function Meta(meta)
    -- local filename = pandoc.utils.stringify(PANDOC_STATE.input_files)

    if meta.tags and #meta.tags > 0 then
        local tags_list = {}

        -- Need to stringify tag values since they are "Inline" Pandoc AST elements
        for i, tag in ipairs(meta.tags) do
            local tag_string = pandoc.utils.stringify(tag)
            tags_list[i] = tag_string
        end

        local tags_list_concat = table.concat(tags_list, ",")
        local tags_string_concat = pandoc.utils.stringify(tags_list_concat)

        io.write(tags_string_concat)
    end

    return meta
end

-- Convert internal links to .html
function Link(el)
    -- Only slugify if link is not pointing to external URL.
    -- Must always include http when inserting external links in markdown.
    if string.find(el.target, "^" .. "http") == nil then
        local slug = slugify(pandoc.utils.stringify(el.content))
        el.target = "/" .. slug
    end

    return el
end

function slugify(str)
    str = str:lower()
    str = str:gsub("['’]", "") -- remove apostrophes
    str = str:gsub("[^a-z0-9]+", "-") -- replace non-alphanumerics with hyphens
    str = str:gsub("^-+", ""):gsub("-+$", "") -- trim leading/trailing hyphens

    return str
end
