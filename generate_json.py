import json
from mkdict import get_all_zhu, get_all_yue

char_to_strokes = {}

lines = open('stroke.dict.yaml').readlines()
for line in lines:
  line = line.strip()
  if line.startswith('#'):
    continue
  if line == '':
    continue
  if '\t' not in line:
    continue
  line_parts = line.split('\t')
  char = line_parts[0]
  strokes = line_parts[1]
  if char not in char_to_strokes:
    char_to_strokes[char] = []
  char_to_strokes[char].append(strokes)

strokes_to_char = {}

for char,strokes_list in char_to_strokes.items():
  for strokes in strokes_list:
    if strokes not in strokes_to_char:
      strokes_to_char[strokes] = []
    strokes_to_char[strokes].append(char)

char_to_zhuyin = {}

for char,_ in char_to_strokes.items():
  char_to_zhuyin[char] = get_all_zhu(char)

char_to_jyutping = {}

for char,_ in char_to_strokes.items():
  char_to_jyutping[char] = get_all_yue(char)

outf = open('index_dist.js', 'wt')
print('var char_to_strokes = ' + json.dumps(char_to_strokes) + ';\n\n', file=outf)
print('var strokes_to_char = ' + json.dumps(strokes_to_char) + ';\n\n', file=outf)
print('var char_to_zhuyin = ' + json.dumps(char_to_zhuyin) + ';\n\n', file=outf)
print('var char_to_jyutping = ' + json.dumps(char_to_jyutping) + ';\n\n', file=outf)
print(open('index.js').read(), file=outf)
