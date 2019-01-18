convert_terminal_char_to_strokes = (char) ->
  output = []
  if char_to_strokes[char]?
    for x in char_to_strokes[char]
      output.push(x)
  special = {
    's': ['s']
    'h': ['h']
    'n': ['n']
    'p': ['p']
    'z': ['z']
    '手': ['hzh', 'hsh'] # 扌
    '食': ['pzz'] # 饣
    '言': ['nz'] # 讠
    '心': ['nsn', 'nns'] # 忄
    '金': ['phhhz'] # 钅
    '人': ['ps'] # 亻
    '耳': ['zzs', 'zs'] # 阝
    '水': ['nnn', 'nnh'] # 氵
    '冰': ['nh'] # 冫
    '衣': ['nhpspn', 'nzspn'] # 衤
    '示': ['nhpsn', 'nzsn'] # 礻
    '雨': ['hnzsnnpn', 'hnzsnnnn']
  }
  if special[char]?
    for x in special[char]
      output.push(x)
  return output

convert_to_strokes = (char_list) ->
  if char_list.length == 0
    return []
  next_char = char_list[0]
  if char_list.length == 1
    return convert_terminal_char_to_strokes(next_char)
  if 'hspnz'.includes next_char
    output = []
    for strokes in convert_to_strokes(char_list.substr(1))
      output.push(next_char + strokes)
    return output
  output = []
  for current_char_strokes in convert_terminal_char_to_strokes(next_char)
    for remaining_strokes in convert_to_strokes(char_list.substr(1))
      output.push(current_char_strokes + remaining_strokes)
  return output

merge_chars = (char_list) ->
  output = []
  output_set = new Set()
  for strokes in convert_to_strokes(char_list)
    if not strokes_to_char[strokes]?
      continue
    for char in strokes_to_char[strokes]
      if output_set.has(char)
        continue
      output_set.add(char)
      output.push(char)
  return output

#main = ->
#  console.log(merge_chars('目青'))

#main()

is_character_valid = (char) ->
  if 'hspnz'.includes(char)
    return true
  if char_to_strokes[char]?
    return true
  return false

return_invalid_characters = (chars) ->
  for x in chars
    if not is_character_valid(x)
      return x
  return ''

display_lines = (lines) ->
  display = $('#display')
  display.html('')
  for x in lines
    display.append($('<div>').html(x))

default_help_lines = [
  'Merges characters and strokes.'
  'Example: enter 目青 to get 睛'
  'You can also use strokes h=一(横) s=丨(竖) n=丶(捺) p=丿(撇) z=乙(折)'
  'Example: enter ps青 to get 倩'
  'Pinyin (Mandarin) and Jyutping (Cantonese) pronunciations are also displayed after the character'
  'For more examples see <a href="https://github.com/zmerge/zmerge.github.io">https://github.com/zmerge/zmerge.github.io</a>'
]

get_zhuyin = (char) ->
  output = char_to_zhuyin[char]
  if output?
    return output.join(' ')
  return ''

get_jyutping = (char) ->
  output = char_to_jyutping[char]
  if output?
    return output.join(' ')
  return ''

text_changed = ->
  newtext = document.querySelector('#textinput').value
  newtext = newtext.split(' ').join('')
  invalid_charaters = return_invalid_characters(newtext)
  if newtext.length == 0
    display_lines default_help_lines
    return
  if invalid_charaters.length > 0
    display_lines ['invalid character ' + invalid_charaters].concat(default_help_lines)
    return
  output = []
  for x in merge_chars(newtext)
    output.push x + ' ' + get_zhuyin(x) + ' ' + get_jyutping(x) + ' ' + convert_terminal_char_to_strokes(x).join(' ')
  display_lines output

main = ->
  #alert('main running')
  document.addEventListener 'DOMContentLoaded', ->
    #alert('dom content loaded')
    textinput = document.querySelector('#textinput')
    textinput.onchange = text_changed
    textinput.onkeyup = text_changed
    display_lines default_help_lines
    textinput.focus()

main()
