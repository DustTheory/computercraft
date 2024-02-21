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

os.loadAPI("gitRepo.lua")
for i=1,#gitRepo.GitLuaFiles do
    shell.run(
        "wget "..gitRepo.GitRepoUrl..GitLuaFiles[i].." git"
    )
end
