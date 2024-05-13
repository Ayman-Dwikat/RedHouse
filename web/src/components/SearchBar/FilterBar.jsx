import React from 'react';
import '../../styles/FilterBar.css';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faFilter } from '@fortawesome/free-solid-svg-icons';
import Select from 'react-select';
import { useRecoilState } from 'recoil';
import { categoryFilterQuery, languageFilterQuery } from '../../state';

const FilterBar = ({ placeholder, options, filterType }) => {
  const [languageFilter, setLanguageFilter] = useRecoilState(languageFilterQuery);
  const [categoryFilter, setCategoryFilter] = useRecoilState(categoryFilterQuery);

  const handleChange = (selectedOption) => {
    if (filterType === 'language') {
      setLanguageFilter(selectedOption.value);
    } else if (filterType === 'category') {
      setCategoryFilter(selectedOption.value);
    }
  };

  return (
    <div className='input-wrapper-f'>
      <FontAwesomeIcon id='search-icon-f' icon={faFilter} />
      <Select
        id='react-select'
        defaultValue={filterType === 'language' ? languageFilter : categoryFilter}
        onChange={handleChange}
        options={options}
        placeholder={placeholder}
        styles={{
          color: 'white',
          control: (baseStyles, state) => ({
            ...baseStyles,
            borderColor: 'transparent',
            boxShadow: state.isFocused ? '0 0 0 2px transparent' : 'none',
            color: 'white',
            backgroundColor: '#000',
            borderRadius: '0px 13px 13px 0px',
            '&:hover': {
              backgroundColor: '#ffffff',
              color: 'black',
              borderColor: 'white',
            },
            '&:focus': {
              backgroundColor: '#ffffff',
              color: 'white',
              borderColor: 'white',
            },
          }),
          option: (styles, { isDisabled, isFocused, isSelected }) => ({
            ...styles,
            color: isSelected ? 'white' : 'black',
            backgroundColor: isSelected ? '#000' : isFocused ? 'gray' : 'white',
          }),
          placeholder: (baseStyles) => ({
            ...baseStyles,
            color: 'white',
            '&:hover': {
              backgroundColor: '#ffffff',
              color: 'black',
              borderColor: 'white',
            },
          }),
          dropdownIndicator: (baseStyles) => ({
            ...baseStyles,
            color: 'white',
          }),
        }}
      />


    </div>
  );
};

export default FilterBar;
