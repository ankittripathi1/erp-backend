export type AuthUser = {
  id: string;
  username: string;
  email: string | null;
  roles: string[];
};
