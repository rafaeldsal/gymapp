import 'jest-preset-angular/setup-jest';

// Mock para localStorage e sessionStorage
const mockStorage = () => {
  let storage: { [key: string]: string } = {};
  return {
    getItem: (key: string) => storage[key] || null,
    setItem: (key: string, value: string) => storage[key] = value,
    removeItem: (key: string) => delete storage[key],
    clear: () => storage = {},
  };
};

Object.defineProperty(window, 'localStorage', { value: mockStorage() });
Object.defineProperty(window, 'sessionStorage', { value: mockStorage() });
Object.defineProperty(window, 'CSS', { value: null });

// Mock para getComputedStyle
Object.defineProperty(window, 'getComputedStyle', {
  value: () => ({
    getPropertyValue: () => ''
  })
});