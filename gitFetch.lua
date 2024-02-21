local GitRepoUrl = "https://raw.githubusercontent.com/DustTheory/computercraft/main/"

shell.run(
    "rm git GitRepo.lua"
)

shell.run(
    "mkdir git"
)

shell.run(
    "wget "..GitRepoUrl.."GitRepo.lua"
)

for i=1,#GitLuaFiles do
    shell.run(
        "wget "..GitRepoUrl..GitLuaFiles[i].." git"
    )
end
