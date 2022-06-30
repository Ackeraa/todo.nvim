local a = {
    x = 3,
    y = 2,
    z = {
        a = 1,
        b = 2,
        c = 3,
    },
}

local opts = {
    xx = 1,
    x = 2,
    z = {
        a = 2,
    },
}

a = vim.tbl_deep_extend("force", a, opts)

P(a)




