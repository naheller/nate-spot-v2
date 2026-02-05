function Meta(meta)
    local filename = pandoc.utils.stringify(PANDOC_STATE.input_files)
    local title = filename:match("([^/]+)%.")
    local slug = title:lower():gsub(" ", "-")
    io.write(slug)

    if meta.title == nil then
        -- Use filename as title in metadata
        meta.title = title
    end

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
-- function Link(el)
--   el.target = string.gsub(el.target, "%.md", ".html")
--   return el
-- end
