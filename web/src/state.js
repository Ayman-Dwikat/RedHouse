import { useContext, useEffect } from 'react'
import { atom, selector, useRecoilState } from 'recoil'
import axios from "axios";


export const posts = atom({
    key: 'posts',
    default: []
})


export const searchedProperties = atom({
    key: 'searchedProperties',
    default: []
})

export const searchedDContracts = atom({
    key: 'searchedDContracts',
    default: []
})

export const requestsState = atom({
    key: 'requests',
    default: []
})

export const isCreatingPost = atom({
    key: 'creating',
    default: false
})


export const filesData = atom({
    key: 'filesPaths',
    default: []
})


export const createdPost = atom({
    key: 'createPost',
    default: {
        title: "",
        description:"",
        userId: "",
        userLanguage: "",
        categories: [],
        filesList: []
      }
})

export const filesList = atom({
    key: 'files',
    default: [{
        filePath:'',
        fileName: ''
    }]
})


export const isUploading = atom({
    key: 'isUploading',
    default: false
})


export const isLoading = atom({
    key: 'isLoading',
    default: false
})


export const Email = atom({
    key: 'Email',
    default: ""
})



export const filesPathsDic = atom({
    key: 'filesPathsDic',
    default: {}
})


export const studentPosts = atom({
    key: 'studentPosts',
    default: []
})

export const PostDetails = atom({
    key: 'PostDetails',
    default: {}
})

export const selectedUser = atom({
    key: 'selectedUser',
    default: {}
})
export const selectedProperty = atom({
    key: 'selectedProperty',
    default: {}
})

export const contractDetails = atom({
    key: 'contractDetails',
    default: {}
})

// export const selectedLanguageOption = atom({
//     key: 'selectedLanguageOption',
//     default: {}
// })

// export const selectedCategoryOption = atom({
//     key: 'selectedCategoryOption',
//     default: {}
// })

export const viewingPostDetails = atom({
    key: 'viewingPostDetails',
    default: false
})

export const keywordQuery = atom({
    key: 'keyword',
    default: ""
})

export const languageFilterQuery = atom({
    key: 'languageFilter',
    default: ""
})

export const categoryFilterQuery = atom({
    key: 'categoryFilter',
    default: ""
})

export const usersRows = atom({
    key: 'usersRows',
    default:[]
})
