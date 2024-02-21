local GitRepoUrl = "https://raw.githubusercontent.com/DustTheory/computercraft/main/"

shell.run(
    "rm git gitRepo.lua"
)

shell.run(
    "mkdir git"
)

shell.run(
    "wget "..GitRepoUrl.."gitRepo.lua"
)

local GitLuaFiles = dofile("gitRepo.lua")
print(GitLuaFiles)
for i=1,#GitLuaFiles do
    local wget = "wget "..GitRepoUrl..GitLuaFiles[i].." git"
    print(wget)
    shell.run(
        wget
    )
end
