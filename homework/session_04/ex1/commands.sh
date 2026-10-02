#!/usr/bin/env bash
# =============================================================================
# commands.sh - Tái hiện toàn bộ thao tác của Bài 1, Session 04
# "Khởi tạo Local Repository và cấu hình danh tính"
#
# Cách dùng:
#   WORKDIR=/duong/dan/thu/muc/thu bash commands.sh > terminal_log.txt 2>&1
# Nếu không đặt WORKDIR, script tạo repo trong thư mục ./_demo (cạnh nơi chạy).
# Script KHÔNG dùng git config --global hay --system.
# =============================================================================

WORKDIR="${WORKDIR:-./_demo}"

# Hàm hỗ trợ: in ra "$ lệnh" rồi chạy lệnh đó, sau đó in một dòng trống.
run() {
  echo "\$ $1"
  eval "$1"
  echo
}

# Hàm hỗ trợ: in tiêu đề từng bước.
step() {
  echo "=============================================================="
  echo "$1"
  echo "=============================================================="
  echo
}

# Không ghi đè một repo demo đã có.
if [ -e "$WORKDIR/my-project" ]; then
  echo "Thư mục $WORKDIR/my-project đã tồn tại, hãy xóa hoặc đổi WORKDIR." >&2
  exit 1
fi
mkdir -p "$WORKDIR" || exit 1
cd "$WORKDIR" || exit 1

# -----------------------------------------------------------------------------
step "Bước 0: Kiểm tra phiên bản Git"
run 'git --version'

# -----------------------------------------------------------------------------
step "Bước 1: Khởi tạo repository trống"
# Tạo thư mục dự án và đi vào trong đó.
run 'mkdir my-project'
run 'cd my-project'
# Khởi tạo repository với nhánh mặc định là main.
run 'git init -b main'
# Thư mục .git (kho lưu trữ) xuất hiện.
run 'ls -la'
# Repo mới chưa có commit nào.
run 'git status'

# -----------------------------------------------------------------------------
step "Bước 2: Trạng thái cấu hình TRƯỚC khi đặt danh tính"
# Cấu hình cấp local lúc này chỉ có các khóa core.* do git init sinh ra.
run 'git config --local --list'
# Chưa có user.name cục bộ: lệnh không in gì và trả về mã thoát 1.
run 'git config --local user.name; echo "exit=$?"'

# -----------------------------------------------------------------------------
step "Bước 3: Cấu hình danh tính ở cấp local (--local)"
# Tên và email chỉ áp dụng cho repo hiện tại, ghi vào .git/config.
run 'git config --local user.name "Lê Toàn"'
run 'git config --local user.email "trinhhanh261293@gmail.com"'
# Ba lệnh kiểm tra theo đề bài.
run 'git config --local user.email'
run 'git config --local user.name'
# Tắt chuyển đổi CRLF để output không có cảnh báo xuống dòng khi chạy trên Windows.
run 'git config --local core.autocrlf false'
# Liệt kê toàn bộ cấu hình cục bộ.
run 'git config --local --list'
# Chứng minh giá trị đến từ file .git/config với scope local.
run 'git config --show-origin --show-scope user.email'
# Xem trực tiếp nội dung file cấu hình của repo.
run 'cat .git/config'

# -----------------------------------------------------------------------------
step "Bước 4: Tạo tệp, đưa vào Staging Area"
# Tạo file bằng printf với xuống dòng LF.
run 'printf "# My Project\n\nDự án mẫu của Session 04, dùng để thực hành Git ở máy cục bộ.\n" > README.md'
run 'printf "print(\"Xin chào, đây là dự án đầu tiên quản lý bằng Git!\")\n" > app.py'
run 'ls -la'
# Hai file mới ở trạng thái untracked.
run 'git status'
# Đưa hai file vào Staging Area.
run 'git add README.md app.py'
run 'git status'
# Xem tóm tắt những gì sẽ được commit.
run 'git diff --cached --stat'

# -----------------------------------------------------------------------------
step "Bước 5: Commit đầu tiên và đọc lịch sử"
run 'git commit -m "feat: khoi tao du an voi README va app.py"'
run 'git status'
run 'git log --oneline'
run 'git log'
run 'git show --stat HEAD'

# -----------------------------------------------------------------------------
step "Bước 6: Commit thứ hai (sửa README)"
# Thêm một đoạn hướng dẫn vào cuối README.md.
run 'printf "\n## Cách chạy\n\nChạy chương trình bằng lệnh: python app.py\n" >> README.md'
# File đã tracked bị sửa: trạng thái modified, chưa staged.
run 'git status'
run 'git diff'
run 'git add README.md'
run 'git commit -m "docs: bo sung huong dan chay chuong trinh"'
run 'git log --oneline'
run 'git log --oneline --graph --decorate'
