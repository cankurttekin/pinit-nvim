local M = {}

-- find project root using .git, fallback to cwd
function M.find_project_root()
    local cwd = vim.fn.getcwd()
    local root = vim.fn.finddir(".git", cwd .. ";")
    if root == "" then return cwd end
    return vim.fn.fnamemodify(root, ":h")
end

-- get project name from git remote or folder name
function M.get_project_name()
    local git_root = M.find_project_root()
    local remote_url = vim.fn.trim(vim.fn.system({ "git", "-C", git_root, "remote", "get-url", "origin" }) or "")
    if remote_url ~= "" and vim.v.shell_error == 0 then
        return remote_url:match("^.+/(.+)%.git$") or remote_url:match("^.+/(.+)$")
    end
    local dir_name = vim.fn.fnamemodify(git_root, ":t")
    return (dir_name == "" or dir_name == ".") and "project" or dir_name
end

return M
