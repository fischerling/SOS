-- Based on:
-- https://pandoc.org/lua-filters.html#center-images-in-latex-and-html-output
-- Licensed under MIT License found at:
-- https://github.com/TomBener/pandoc-templates/blob/05aba224519d8a2b037108948bde0d820860b786/LICENSE

-- Filter images with this function if the target format is LaTeX.
if FORMAT:match('beamer') then
  function Image(elem)
    -- Surround all images with the 'center' class with image-centering raw LaTeX.
    if elem.classes[1] == "center" then
      return {
        pandoc.RawInline('latex', '\\hfill\\break{\\centering'),
        elem,
        pandoc.RawInline('latex', '\\par}')
      }
    else
      return elem
    end
  end
end
