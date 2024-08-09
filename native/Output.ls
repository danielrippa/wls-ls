
  do ->

    { item-count, first-item, fold-array, map-items } = dependency native.Array
    { maximum } = dependency native.Number
    { object-keys, object-from-arrays, object-from-array } = dependency native.Object
    { array-as-units, array-as-records, array-as-groups, entity-encode } = dependency native.String

    new-column-metadata = (name, type, width = -1, style = 'plain') -> { name, type, width, style }

    new-column-metadata-for-index = (index) -> new-column-metadata "Column#index", "Str", -1, 'plain'

    columns-metadata-from-column-count = (column-count = 1) -> [ (new-column-metadata-for-index index) for index til column-count ]

    max-column-count-for-array = (array, max) -> maximum max, item-count array

    max-column-count-for-arrays = (arrays) -> fold-array arrays, 0, (max, array) -> maximum max, max-column-count-for-array array, max

    field-values = (field-name, columns) -> [ (column[field-name]) for column in columns ]

    field-values-as-units = (field-name, columns) -> field-name `field-values` columns  |> array-as-units

    columns-metadata-as-records = (columns) ->

      names  = field-values-as-units \name,  columns
      types  = field-values-as-units \type,  columns
      widths = field-values-as-units \width, columns
      styles = field-values-as-units \style, columns

      [ names, types, widths, styles ] |> array-as-records

    columns-metadata-for-arrays = (arrays) ->

      max-column-count = max-column-count-for-arrays arrays

      columns-metadata-from-column-count max-column-count

    items-as-units = (array) -> map-items array, entity-encode |> array-as-units

    arrays-as-records = (arrays) -> arrays |> map-items _ , items-as-units |> array-as-records

    arrays-as-output = (arrays, metadata) ->

      output = ''

      if (item-count arrays) > 0
        if (item-count first-item arrays) > 0

          if metadata is void
            metadata = columns-metadata-for-arrays arrays

          metadata-records = metadata |> columns-metadata-as-records
          data-records = arrays |> arrays-as-records

          output = [ metadata-records, data-records ] |> array-as-groups

      output

    {
      new-column-metadata,
      arrays-as-output
    }