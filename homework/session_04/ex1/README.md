# Bài 1 - Khởi tạo Local Repository và cấu hình danh tính

Môn DevOps, Session 04. Báo cáo này được viết từ output thật của Git, chạy trên máy cá nhân. Toàn bộ lệnh và output nguyên văn nằm trong `terminal_log.txt`; script tái hiện là `commands.sh`.

## 1. Mục tiêu

- Khởi tạo một Git repository trống tại thư mục làm việc cục bộ.
- Thiết lập danh tính tác giả (tên và email) ở cấp local, bắt buộc dùng `--local`, không dùng `--global`.
- Tạo tệp mới, đưa vào Staging Area và thực hiện commit đầu tiên.
- Đọc và phân tích trạng thái thư mục làm việc và lịch sử commit qua `git status`, `git log`.

Bối cảnh: học viên bắt đầu một dự án phần mềm mới (đặt tên `my-project`) và muốn quản lý mã nguồn bằng Git ở local.

## 2. Môi trường

| Hạng mục | Giá trị |
| --- | --- |
| Hệ điều hành | Windows 11 |
| Shell | Git Bash (POSIX sh) |
| Phiên bản Git | `git version 2.49.0.windows.1` |
| Nhánh mặc định | `main` (chỉ định qua `git init -b main`) |
| Tên tác giả (local) | `Lê Toàn` |
| Email tác giả (local) | `trinhhanh261293@gmail.com` |

Ghi chú về xuống dòng: trên Windows, Git có thể chuyển đổi LF/CRLF và in cảnh báo `LF will be replaced by CRLF`. Để output sạch và dễ đối chiếu, các tệp được tạo bằng `printf` với xuống dòng LF, đồng thời đặt `git config --local core.autocrlf false` (chỉ áp dụng cho repo này). Nhờ vậy Git không sửa nội dung tệp khi `add`/`commit`.

## 3. Các bước thực hiện

Các output dưới đây được chép nguyên văn từ `terminal_log.txt`.

### Bước 1. Khởi tạo repository

```text
$ mkdir my-project

$ cd my-project

$ git init -b main
Initialized empty Git repository in D:/Rikkei/DevOps/Session4/_demo/bai1/my-project/.git/

$ ls -la
total 4
drwxr-xr-x 1 gigabyte 197610 0 Oct  2 12:47 .
drwxr-xr-x 1 gigabyte 197610 0 Oct  2 12:47 ..
drwxr-xr-x 1 gigabyte 197610 0 Oct  2 12:47 .git

$ git status
On branch main

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

Giải thích:

- `git init -b main` tạo thư mục ẩn `.git` (toàn bộ cơ sở dữ liệu của repo: object, ref, config) và đặt nhánh khởi đầu là `main`. Đường dẫn trong dòng "Initialized empty Git repository" là đường dẫn thư mục demo thật mà tôi dùng để chạy lệnh.
- `ls -la` cho thấy thư mục chỉ có `.git`, chưa có tệp nào của dự án.
- `git status` báo `No commits yet`: nhánh `main` tồn tại về tên nhưng chưa trỏ tới commit nào. Đây là trạng thái "unborn branch".

### Bước 2. Cấu hình trước khi đặt danh tính

```text
$ git config --local --list
core.repositoryformatversion=0
core.filemode=false
core.bare=false
core.logallrefupdates=true
core.symlinks=false
core.ignorecase=true

$ git config --local user.name; echo "exit=$?"
exit=1
```

Giải thích:

- Cấu hình local ngay sau `git init` chỉ có các khóa `core.*` do Git tự sinh. Trên Windows có thêm `core.filemode=false`, `core.symlinks=false`, `core.ignorecase=true` do hệ thống tệp NTFS không phân biệt hoa thường và không theo dõi quyền thực thi kiểu Unix.
- Chưa có mục `[user]` nào trong cấu hình local. Lệnh `git config --local user.name` không in gì và trả mã thoát `1` (mã 1 nghĩa là khóa không tồn tại ở phạm vi được hỏi). Đây là bằng chứng "trước" để so sánh với "sau".

### Bước 3. Cấu hình danh tính cấp local

```text
$ git config --local user.name "Lê Toàn"

$ git config --local user.email "trinhhanh261293@gmail.com"

$ git config --local user.email
trinhhanh261293@gmail.com

$ git config --local user.name
Lê Toàn

$ git config --local core.autocrlf false

$ git config --local --list
core.repositoryformatversion=0
core.filemode=false
core.bare=false
core.logallrefupdates=true
core.symlinks=false
core.ignorecase=true
core.autocrlf=false
user.name=Lê Toàn
user.email=trinhhanh261293@gmail.com

$ git config --show-origin --show-scope user.email
local	file:.git/config	trinhhanh261293@gmail.com

$ cat .git/config
[core]
	repositoryformatversion = 0
	filemode = false
	bare = false
	logallrefupdates = true
	symlinks = false
	ignorecase = true
	autocrlf = false
[user]
	name = Lê Toàn
	email = trinhhanh261293@gmail.com
```

Giải thích:

- Hai lệnh `git config --local user.name ...` và `user.email ...` ghi giá trị vào file `.git/config` của repo này. Không có tùy chọn `--global` hay `--system` nào được dùng.
- Hai lệnh kiểm tra `git config --local user.email` và `git config --local user.name` in đúng email và tên vừa cấu hình, đúng theo yêu cầu kiểm tra của đề.
- `git config --local --list` hiển thị đầy đủ cấu hình cục bộ: ngoài các khóa `core.*` ban đầu có thêm `core.autocrlf=false`, `user.name` và `user.email`.
- `git config --show-origin --show-scope user.email` in ba cột ngăn cách bằng tab: scope là `local`, nguồn là `file:.git/config`, giá trị là email. Đây là bằng chứng giá trị đến từ cấp local, từ file `.git/config` của dự án.
- `cat .git/config` cho thấy cùng thông tin dưới dạng file INI thô, với hai section `[core]` và `[user]`.

### Bước 4. Tạo tệp và đưa vào Staging Area

```text
$ printf "# My Project\n\nDự án mẫu của Session 04, dùng để thực hành Git ở máy cục bộ.\n" > README.md

$ printf "print(\"Xin chào, đây là dự án đầu tiên quản lý bằng Git!\")\n" > app.py

$ ls -la
total 6
drwxr-xr-x 1 gigabyte 197610  0 Oct  2 12:47 .
drwxr-xr-x 1 gigabyte 197610  0 Oct  2 12:47 ..
drwxr-xr-x 1 gigabyte 197610  0 Oct  2 12:47 .git
-rw-r--r-- 1 gigabyte 197610 97 Oct  2 12:47 README.md
-rw-r--r-- 1 gigabyte 197610 75 Oct  2 12:47 app.py

$ git status
On branch main

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	README.md
	app.py

nothing added to commit but untracked files present (use "git add" to track)

$ git add README.md app.py

$ git status
On branch main

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
	new file:   README.md
	new file:   app.py


$ git diff --cached --stat
 README.md | 3 +++
 app.py    | 1 +
 2 files changed, 4 insertions(+)
```

Giải thích:

- Hai tệp được tạo trong Working Directory. `git status` liệt kê chúng ở mục `Untracked files`: Git thấy tệp nhưng chưa theo dõi.
- `git add README.md app.py` sao chép ảnh chụp (snapshot) nội dung hiện tại của hai tệp vào Staging Area (index). Từ đây `git status` chuyển sang mục `Changes to be committed` với nhãn `new file`.
- `git diff --cached --stat` so sánh Staging Area với commit gần nhất (ở đây chưa có commit nào nên so với "rỗng"): `README.md` thêm 3 dòng, `app.py` thêm 1 dòng, tổng 4 dòng được thêm.

### Bước 5. Commit đầu tiên và đọc lịch sử

```text
$ git commit -m "feat: khoi tao du an voi README va app.py"
[main (root-commit) 83c8dc5] feat: khoi tao du an voi README va app.py
 2 files changed, 4 insertions(+)
 create mode 100644 README.md
 create mode 100644 app.py

$ git status
On branch main
nothing to commit, working tree clean

$ git log --oneline
83c8dc5 feat: khoi tao du an voi README va app.py

$ git log
commit 83c8dc54d7ec6f77b310a1285da985f94e943f14
Author: Lê Toàn <trinhhanh261293@gmail.com>
Date:   Fri Oct 2 12:47:49 2026 +0700

    feat: khoi tao du an voi README va app.py

$ git show --stat HEAD
commit 83c8dc54d7ec6f77b310a1285da985f94e943f14
Author: Lê Toàn <trinhhanh261293@gmail.com>
Date:   Fri Oct 2 12:47:49 2026 +0700

    feat: khoi tao du an voi README va app.py

 README.md | 3 +++
 app.py    | 1 +
 2 files changed, 4 insertions(+)
```

Giải thích:

- Dòng `[main (root-commit) 83c8dc5]` cho biết commit nằm trên nhánh `main`, là root-commit (commit gốc, không có commit cha) và có mã rút gọn `83c8dc5`. Dòng `create mode 100644` báo hai tệp thường (không thực thi) được ghi nhận.
- Sau commit, `git status` báo `working tree clean`: Working Directory, Staging Area và commit mới nhất hoàn toàn khớp nhau.
- `git log --oneline` hiển thị đúng 1 commit với thông điệp rõ nghĩa, đáp ứng tiêu chí kiểm tra của đề.
- `git log` đầy đủ cho thấy dòng `Author: Lê Toàn <trinhhanh261293@gmail.com>`, trùng khớp danh tính đã cấu hình cục bộ. Git lấy thông tin này từ `user.name`/`user.email` ở bước 3.
- `git show --stat HEAD` cho xem commit mới nhất kèm thống kê tệp bị thay đổi.
- Lưu ý: log được chạy với đầu ra chuyển hướng vào file nên `git log` không hiển thị phần trang trí `(HEAD -> main)` (cấu hình `log.decorate=auto` chỉ trang trí khi đầu ra là terminal). Bước 6 dùng `--decorate` để hiển thị rõ.

### Bước 6. Commit thứ hai (sửa README)

```text
$ printf "\n## Cách chạy\n\nChạy chương trình bằng lệnh: python app.py\n" >> README.md

$ git status
On branch main
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")

$ git diff
diff --git a/README.md b/README.md
index 7ab5be5..1367b80 100644
--- a/README.md
+++ b/README.md
@@ -1,3 +1,7 @@
 # My Project
 
 Dự án mẫu của Session 04, dùng để thực hành Git ở máy cục bộ.
+
+## Cách chạy
+
+Chạy chương trình bằng lệnh: python app.py

$ git add README.md

$ git commit -m "docs: bo sung huong dan chay chuong trinh"
[main dc36f2c] docs: bo sung huong dan chay chuong trinh
 1 file changed, 4 insertions(+)

$ git log --oneline
dc36f2c docs: bo sung huong dan chay chuong trinh
83c8dc5 feat: khoi tao du an voi README va app.py

$ git log --oneline --graph --decorate
* dc36f2c (HEAD -> main) docs: bo sung huong dan chay chuong trinh
* 83c8dc5 feat: khoi tao du an voi README va app.py
```

Giải thích:

- `README.md` đã được theo dõi (tracked) nên khi sửa, `git status` chuyển sang `Changes not staged for commit` với nhãn `modified`: thay đổi mới chỉ nằm ở Working Directory.
- `git diff` (không tham số) so sánh Working Directory với Staging Area; các dòng bắt đầu bằng `+` là nội dung mới thêm. Dòng `@@ -1,3 +1,7 @@` nghĩa là đoạn gốc 3 dòng nay thành 7 dòng. Hai chuỗi `7ab5be5..1367b80` là mã rút gọn của phiên bản cũ và mới của tệp.
- `git add README.md` đưa thay đổi vào Staging Area; `git commit` tạo commit thứ hai `dc36f2c` (không có chữ `root-commit` vì đã có commit cha).
- `git log --oneline` liệt kê commit mới nhất ở trên cùng. Biểu đồ `--graph --decorate` cho thấy lịch sử tuyến tính một nhánh, `HEAD -> main` đánh dấu commit hiện tại.

## 4. Phân tích

### 4.1. Ba vùng: Working Directory, Staging Area, Repository

```text
 Working Directory          Staging Area (index)          Repository (.git)
 (thu muc lam viec)         (vung cho commit)             (lich su commit)
 +------------------+       +------------------+          +------------------+
 | README.md        |       |                  |          |                  |
 | app.py           | ----> |  snapshot cua    | -------> |  commit 83c8dc5  |
 | (sua file o day) | git   |  cac file da add | git      |  commit dc36f2c  |
 |                  | add   |                  | commit   |                  |
 +------------------+       +------------------+          +------------------+
          ^                                                         |
          |                    git checkout / git restore           |
          +---------------------------------------------------------+
```

- Working Directory: các tệp thật trên đĩa mà ta đang chỉnh sửa.
- Staging Area (index): "giỏ hàng" chứa ảnh chụp những thay đổi sẽ được đưa vào commit tiếp theo. Nhờ vùng này ta chọn được chính xác tệp, thậm chí từng đoạn thay đổi, sẽ vào commit.
- Repository: cơ sở dữ liệu trong `.git` lưu các commit bất biến. Mỗi commit là một snapshot của toàn bộ dự án kèm tác giả, thời gian, thông điệp và con trỏ tới commit cha.

### 4.2. Vòng đời trạng thái của tệp

```text
  Untracked ---- git add ----> Staged ---- git commit ----> Committed (clean)
      ^                          ^                              |
      |                          |                              | sua file
      |                          +------- git add -------- Modified
      |                                                        ^
      +---- (tep moi tao)                                      |
                                              Committed <------+
```

Đối chiếu với thực tế trong bài:

| Trạng thái | Thể hiện trong output | Thời điểm |
| --- | --- | --- |
| Untracked | `Untracked files: README.md app.py` | Sau khi tạo tệp (bước 4) |
| Staged | `Changes to be committed: new file: ...` | Sau `git add` (bước 4) |
| Committed | `nothing to commit, working tree clean` | Sau commit đầu tiên (bước 5) |
| Modified | `Changes not staged for commit: modified: README.md` | Sau khi sửa README (bước 6) |
| Staged lần hai, rồi Committed | `git add` và `git commit` tiếp theo | Bước 6 |

### 4.3. Ba cấp cấu hình và thứ tự ưu tiên

Git đọc cấu hình từ ba cấp. Cấp càng hẹp thì ưu tiên càng cao: khi cùng một khóa xuất hiện ở nhiều cấp, giá trị ở cấp hẹp hơn sẽ thắng.

| Cấp | Phạm vi | Vị trí lưu | Ưu tiên |
| --- | --- | --- | --- |
| `--system` | Mọi người dùng trên máy | File cấu hình hệ thống của bản cài Git | Thấp nhất |
| `--global` | Mọi repo của người dùng hiện tại | `~/.gitconfig` | Trung bình |
| `--local` | Chỉ repo hiện tại | `.git/config` | Cao nhất |

```text
  system  (toan may)
     |   bi ghi de boi
     v
  global  (moi repo cua user)
     |   bi ghi de boi
     v
  local   (chi repo nay)  <-- gia tri duoc dung khi commit
```

Trong bài này, `git config --show-origin --show-scope user.email` trả về scope `local` và nguồn `file:.git/config`, xác nhận giá trị email được lấy từ cấp local của dự án.

### 4.4. Vì sao dùng `--local` cho dự án này

- Cô lập danh tính theo dự án: một người thường có nhiều danh tính (email công ty, email cá nhân, email lớp học). Đặt ở cấp local bảo đảm mọi commit của `my-project` mang đúng danh tính của dự án này, không rò sang repo khác.
- Không sửa cấu hình toàn cục: `--global` thay đổi mọi repo của người dùng, có thể gây commit sai email ở dự án khác.
- Tính tái lập: cấu hình nằm ngay trong `.git/config` của repo, kiểm tra được bằng `git config --local --list` và truy nguyên nguồn bằng `--show-origin`.
- Thực tế thao tác: mỗi commit bắt buộc ghi tác giả; nếu không cấu hình rõ `user.name`/`user.email`, Git có thể báo lỗi hoặc tự đoán từ tên máy và ghi sai danh tính. Đặt cấp local là cách đơn giản và an toàn nhất để tránh tình huống này.
- Lưu ý nhỏ: `.git/config` không được đẩy lên remote khi `push`, nên danh tính local chỉ tồn tại ở máy chứa repo. Mỗi lần clone mới cần cấu hình lại.

### 4.5. Cách đọc `git log --oneline` và `git log` đầy đủ

Một dòng `git log --oneline`:

```text
83c8dc5 feat: khoi tao du an voi README va app.py
|       |
|       +-- dong dau tien cua thong diep commit (subject)
+---------- ma bam (hash) rut gon cua commit, 7 ky tu dau
```

Một mục `git log` đầy đủ:

```text
commit 83c8dc54d7ec6f77b310a1285da985f94e943f14      <- ma SHA-1 day du (40 ky tu hex), dinh danh duy nhat cua commit
Author: Lê Toàn <trinhhanh261293@gmail.com>          <- ten va email lay tu user.name, user.email luc commit
Date:   Fri Oct 2 12:47:49 2026 +0700                 <- thoi diem tao commit, kem mui gio
                                                      <- dong trong ngan cach header va thong diep
    feat: khoi tao du an voi README va app.py        <- thong diep commit (thut le 4 dau cach)
```

Với commit thứ hai, `git log --oneline --graph --decorate` bổ sung `(HEAD -> main)`: `HEAD` là con trỏ tới vị trí hiện tại, `main` là tên nhánh; dấu `*` là một commit trong đồ thị. Thứ tự hiển thị từ mới nhất tới cũ nhất.

Về thông điệp commit: dùng tiền tố theo chuẩn Conventional Commits (`feat:` cho tính năng mới, `docs:` cho thay đổi tài liệu) giúp lịch sử dễ đọc và dễ lọc. Hai thông điệp trong bài viết tiếng Việt không dấu để tránh vấn đề mã hóa ký tự ở các môi trường khác nhau.

## 5. Bảng tổng hợp lệnh đã dùng

| Lệnh | Tác dụng |
| --- | --- |
| `git init -b main` | Khởi tạo repo trống, nhánh khởi đầu là `main` |
| `git status` | Xem trạng thái Working Directory và Staging Area |
| `git config --local --list` | Liệt kê cấu hình cấp local |
| `git config --local user.name "..."` | Đặt tên tác giả cho riêng repo này |
| `git config --local user.email "..."` | Đặt email tác giả cho riêng repo này |
| `git config --local user.name` / `user.email` | Đọc lại giá trị đã đặt (lệnh kiểm tra của đề) |
| `git config --local core.autocrlf false` | Tắt chuyển đổi LF/CRLF cho repo này |
| `git config --show-origin --show-scope user.email` | Cho biết giá trị đến từ scope nào, file nào |
| `git add README.md app.py` | Đưa hai tệp vào Staging Area |
| `git diff --cached --stat` | Thống kê thay đổi đang ở Staging Area |
| `git commit -m "..."` | Tạo commit từ nội dung Staging Area |
| `git log --oneline` | Lịch sử rút gọn, mỗi commit một dòng |
| `git log` | Lịch sử đầy đủ: hash, tác giả, ngày, thông điệp |
| `git show --stat HEAD` | Chi tiết commit mới nhất kèm thống kê tệp |
| `git diff` | Xem thay đổi chưa staged (Working Directory so với index) |
| `git log --oneline --graph --decorate` | Lịch sử rút gọn dạng đồ thị, có nhãn `HEAD`, nhánh |

## 6. Đối chiếu yêu cầu đề bài

| Yêu cầu | Cách đáp ứng | Bằng chứng |
| --- | --- | --- |
| Khởi tạo Git repository trống | `git init -b main` | Bước 1: `Initialized empty Git repository`, có thư mục `.git` |
| Thiết lập tên và email ở cấp local, dùng `--local`, không dùng `--global` | `git config --local user.name` và `user.email` | Bước 3: không có lệnh nào dùng `--global` hoặc `--system` |
| Kiểm tra `git config --local user.email` | Chạy đúng lệnh | In ra `trinhhanh261293@gmail.com` |
| Kiểm tra `git config --local user.name` | Chạy đúng lệnh | In ra `Lê Toàn` |
| Tạo tệp mới, đưa vào Staging Area | `printf`, `git add README.md app.py` | Bước 4: `Changes to be committed` |
| Commit đầu tiên với thông điệp rõ nghĩa | `git commit -m "feat: khoi tao du an voi README va app.py"` | Bước 5: commit `83c8dc5` (root-commit) |
| `git log --oneline` hiển thị tối thiểu 1 commit | Chạy đúng lệnh | Bước 5 hiển thị 1 commit; bước 6 hiển thị 2 commit |
| Đọc và phân tích trạng thái, lịch sử | `git status`, `git log`, `git show`, `git diff` | Mục 3 và mục 4 |
| README liệt kê lệnh (init, config local, add, commit) kèm kết quả `git log --oneline` và `git config --local --list` | Mục 3 và mục 5 | Output nguyên văn ở bước 3, 5, 6 |
| "Ảnh chụp" kết quả | Thay bằng output text trong code block (đề cho phép "ảnh chụp hoặc kết quả chạy lệnh") | `terminal_log.txt` |

## 7. Kết luận

- Repository `my-project` được khởi tạo bằng `git init -b main`; cấu hình trước và sau cho thấy rõ việc `user.name` và `user.email` được thêm vào `.git/config` ở scope `local`, không đụng tới cấu hình toàn cục.
- Quy trình cơ bản đã được thực hành đầy đủ: tạo tệp (untracked) -> `git add` (staged) -> `git commit` (committed) -> sửa tệp (modified) -> `git add` -> `git commit`. Mỗi trạng thái đều có output `git status` làm bằng chứng.
- Lịch sử cuối cùng gồm 2 commit: `83c8dc5` (feat) và `dc36f2c` (docs). Trường `Author` trong `git log` khớp đúng danh tính cục bộ.
- Dùng `--local` giúp danh tính gắn chặt với từng dự án, tránh nhầm lẫn khi làm việc với nhiều repo và nhiều danh tính.
- Hash và ngày giờ trong báo cáo là giá trị của lần chạy thật; chạy lại `commands.sh` sẽ cho hash và thời gian khác vì chúng phụ thuộc vào thời điểm commit.

## 8. Cấu trúc thư mục bài nộp

```text
homework/session_04/ex1/
|-- README.md            (báo cáo này)
|-- terminal_log.txt     (toàn bộ lệnh và output thật)
|-- commands.sh          (script tái hiện thao tác)
`-- my-project/
    |-- README.md        (bản sao tệp cuối cùng của repo demo)
    `-- app.py
```

Thư mục `my-project/` ở đây chỉ chứa bản sao hai tệp cuối cùng, không bao gồm thư mục `.git` của repo demo.
