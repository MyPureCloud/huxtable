class Fixtable

  _bindElements: (el) ->
    @el = $ el
    @headers = @el.find 'thead'

  _bindEvents: ->
    console.log 'foo'

  _getHeaderHeight: ->
    return @headers.find('div').outerHeight()

  _setColumnWidth: (column, columnWidth) ->
    if typeof column is 'number'
      header = @headers.find 'th:nth-of-type(' + column + ')'
    else if typeof column is 'object'
      header = column
    else
      header = @headers.find column

    columnWidth = parseInt(columnWidth) + 'px'

    header.css
      'max-width': columnWidth
      'min-width': columnWidth
      'width': columnWidth

  _circulateStyles: ->
    if @_stylesCirculated then return
    @_stylesCirculated = true

    headers = @headers.find 'th'
    newHeaders = @headers.find 'th > div'
    headers.each (index, header) ->
      theHeader = headers[index]
      newHeader = newHeaders[index]
      computedHeaderStyles = window.getComputedStyle(theHeader)

      # propagate header styles to fixtable headers
      newHeader.style.padding = computedHeaderStyles.padding
      newHeader.style.margin = computedHeaderStyles.margin
      newHeader.style.border = computedHeaderStyles.border

      # reset original header styles
      theHeader.style.padding = '0'
      theHeader.style.margin = '0'
      theHeader.style.border = 'none'

    theTable = @el.find('table').get(0)
    computedTableStyles = window.getComputedStyle(theTable)
    @el.css 
      padding: computedTableStyles.padding
      margin: computedTableStyles.margin
      border: computedTableStyles.border

    theTable.style.padding = '0'
    theTable.style.margin = '0'
    theTable.style.border = 'none'


  _setHeaderHeight: ->

    for th in @headers.find 'th'
      th = $ th
      th.find('div').css
        'width': th.outerWidth()

    headerHeight = @_getHeaderHeight() + 'px'
    @el.css 'padding-top', headerHeight
    @el.find('.fixtable-header').css 'height', headerHeight

  constructor: (el) ->
    @_bindElements el