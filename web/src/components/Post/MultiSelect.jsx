import React from 'react'
import { useState } from 'react'
import Multiselect from 'multiselect-react-dropdown';

const MultiSelect = () => {
    const [categories, setCategories] = useState(["Vocabulary", "Practice Sheets", "Written Texts", "Grammar Practice", "Visuals/Images", "Parts of Speech",
    "Presentations", "Infographics", "Verbs", "Adjectives", "Nouns"])
  return (
    <div>
        <Multiselect
            isObject={false}
            onRemove={(e) => {console.log(e)}}
            onSelect={(e) => {console.log(e)}}
            options={categories}
        />
    </div>
  )
}

export default MultiSelect