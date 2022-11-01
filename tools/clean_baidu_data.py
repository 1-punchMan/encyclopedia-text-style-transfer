import json
import linecache

LEXICAL_ENTRY_TITLES = [
    "词语",
    "成语",
    "词汇"
]

def process(file_path, title_file_path=None, metadata=None):
    
    def get_metadata():
        if title_file_path is not None:
            with open(title_file_path, 'r', encoding='utf-8') as f:
                meta = json.load(f)
            return list(meta.items())
        elif metadata is not None:
            return [(n, title) for title, (n, _) in metadata.items()]
    
    with open(file_path, 'r', encoding='utf-8') as f:

        def update_info(prev_title, info, repetitions, prev_n, start, cnt, rep_cnt):
            
            if prev_title in info:
                if prev_title not in repetitions:
                    repetitions[prev_title] = []
                repetitions[prev_title].append((start, cnt))
                rep_cnt += 1
            else:
                info[prev_title] = (prev_n, (start, cnt))

            return rep_cnt

        meta = get_metadata()
        info = {}
        cnt = rep_cnt = 0   # 1-based
        finished = successfully_finish = False
        repetitions = {}
        for i, (n, title) in enumerate(meta):
            while True:
                line = f.readline()
                cnt += 1
                if line == "":
                    rep_cnt = update_info(prev_title, info, repetitions, prev_n, start, cnt, rep_cnt)
                    assert len(info) + rep_cnt == i + 1, (len(info), rep_cnt, i, n, title, cnt)
                    successfully_finish = True
                    break
                if not finished and line.strip() == title:
                    if i > 0:
                        rep_cnt = update_info(prev_title, info, repetitions, prev_n, start, cnt, rep_cnt)
                        assert len(info) + rep_cnt == i, (len(info), rep_cnt, i, n, title)
                    start = cnt
                    prev_title, prev_n = (
                        title,
                        n
                    )
                    if i == len(meta) - 1:
                        finished = True
                    else:
                        break
         
    if successfully_finish:
        print("Finish")
    else:
        print("Abnormal termination")
    
    assert len(info) + rep_cnt == len(meta), (len(info), len(meta), rep_cnt)
    print(f"Found {rep_cnt} repetitions.")
    return info, repetitions
    
def save_metadata(metadata, out_path):
    with open(out_path, 'w', encoding='utf-8') as f:
        json.dump(metadata, f, ensure_ascii=False)
        
def clean(file_path, metadata, repetitions, out_path):
    """ Remove repeated and lexical entries """
    
    def get_repetitions(repetitions):
        return [interval for intervals in repetitions.values() for interval in intervals]
            
    def get_lexical(metadata):
        removing = []
        for title, (_, (start, end)) in list(metadata.items()):
            first_line = linecache.getline(file_path, start + 1)
            remove = False
            for word in LEXICAL_ENTRY_TITLES:
                if word in title or word in first_line:
                    metadata.pop(title)
                    remove = True
                    break

            if remove:
                removing.append((start, end))

        return removing
            
    def get_removing_interval(repetitions, metadata):
        removing = get_repetitions(repetitions) + get_lexical(metadata)
        removing.sort(key=lambda x: x[0])
        for interval in removing:
            yield interval
    
    with open(file_path, 'r', encoding='utf-8') as f:
        text = ""
        start = 1   # 1-based
        for r_start, r_end in get_removing_interval(repetitions, metadata):
            end = r_start
            for _ in range(start, end):
                text += f.readline()
                
            for _ in range(r_start, r_end):
                f.readline()
                
            start = r_end
            
        while True:
            line = f.readline()
            if line == "":
                break
            text += line
    
    with open(out_path, 'w', encoding='utf-8') as f:
        f.write(text)
            
print("Start processing ...")
            
file_path = "/home/zchen/encyclopedia-text-style-transfer/data/ETST/baidu/raw_data/articles4"
title_file_path = "/home/zchen/encyclopedia-text-style-transfer/data/ETST/baidu/raw_data/titles4.json"
metadata1, repetitions = process(file_path, title_file_path=title_file_path)
            
print()
print("Start cleaning ...")

out_path = "/home/zchen/encyclopedia-text-style-transfer/data/ETST/baidu/processed_data/cleaned/articles4"
clean(file_path, metadata1, repetitions, out_path)
            
print()
print("Start processing after cleaning ...")
            
file_path = out_path
metadata2, repetitions = process(file_path, metadata=metadata1)

out_path = "/home/zchen/encyclopedia-text-style-transfer/data/ETST/baidu/processed_data/cleaned/metadata4.json"
save_metadata(metadata2, out_path)